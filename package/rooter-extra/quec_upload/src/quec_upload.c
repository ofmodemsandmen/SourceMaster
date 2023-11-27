#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <termios.h>
#include <sys/select.h>
#include <time.h>
#include <sys/types.h>
#include <sys/stat.h>

#define READ_OK        (-1)
#define READ_ERROR     (-2)
#define READ_NOTHING   (-3)
#define READ_EXCEPT    (-4)
#define READ_CONNECT   (-5)
#define READ_END       (-6)

#define QFUPL_TX_SIZE  (4 * 1024)

int pOpenPort(const char * port)
{
    struct termios newtio;

    int lFd = open(port, O_RDWR | O_NDELAY);
    if (lFd != -1) {
        /* read operations are set to blocking according to the VTIME value */
        fcntl(lFd, F_SETFL, 0);

        tcgetattr(lFd, &newtio);

        tcflush(lFd, TCIOFLUSH);

        /* Set to 115200 */
        cfsetispeed(&newtio, B115200);
        cfsetospeed(&newtio, B115200);
        /*set char bit size*/
        newtio.c_cflag &= ~CSIZE;
        newtio.c_cflag |= CS8;
        newtio.c_cflag &= ~CSTOPB;
        newtio.c_cflag |= CLOCAL | CREAD;
        newtio.c_cflag &= ~(PARENB | PARODD);

        newtio.c_iflag &=
            ~(INPCK | BRKINT | PARMRK | ISTRIP | INLCR | IGNCR | ICRNL);
        newtio.c_iflag |= IGNBRK;
        newtio.c_iflag &= ~(IXON | IXOFF | IXANY);

        newtio.c_lflag = 0;
        newtio.c_oflag = 0;
        /*set wait time*/
        newtio.c_cc[VMIN] = 0;
        newtio.c_cc[VTIME] = 20;

        tcflush(lFd, TCIFLUSH);
        tcsetattr(lFd, TCSANOW, &newtio);

        return(lFd);
    } /* endif */

    return(-1);
}

int pGetErrorCode(char * pBuffer)
{
    int lErrorCode = -1;

    char * lPtr = strstr(pBuffer, "+CME ERROR");

    if (lPtr != (char *)NULL) {
        lPtr += strlen("+CME ERROR:");
        lErrorCode = atoi(lPtr);
    } /* endif */

    return(lErrorCode);
}

int pSendCommand(int fd, char * command)
{
    char cmdBuffer[255];
    int lCmdLen = strlen(command);
    int lRes;

    strcpy(cmdBuffer, command); strcat(cmdBuffer, "\r");
    lCmdLen ++;

    lRes = write(fd, cmdBuffer, lCmdLen);
    if (lRes != lCmdLen) {
        return(-1);
    } else {
        return(0);
    } 
}

int pReadLine(int fd, char * buffer, int pBufLen)
{
    int count;
    int lRes;
    int read_sum = 0;

    fd_set lReadFds, lExceptFds;
    struct timeval lTimeout;

    FD_ZERO(&lReadFds);
    FD_ZERO(&lExceptFds);
    FD_SET(fd, &lReadFds);
    FD_SET(fd, &lExceptFds);
    lTimeout.tv_sec = 1;
    lTimeout.tv_usec = 0;

    lRes = select(1+fd, &lReadFds, NULL, &lExceptFds, &lTimeout);
    if (lRes == 0) {
        return(READ_NOTHING);
    } /* endif */

    if ((lRes < 0) || (FD_ISSET(fd, &lExceptFds))) {
        return(READ_EXCEPT);
    } /* endif */

    /* read characters into our string buffer until we get a CR or NL */
    while ((count = read(fd, &buffer[read_sum], pBufLen - read_sum)) > 0) {
        read_sum += count;
        if (buffer[read_sum-1] == '\n' || buffer[read_sum-1] == '\r')
            break;
    } /* endwhile */

    if (count < 0) {
        return(READ_EXCEPT);
    } /* endif */

    /* nul terminate the string and see if we got an OK response */
    buffer[read_sum] = '\0';

    if (strstr(buffer, "\nOK") != (char *)NULL) {
        return (READ_OK);
    } /* endif */
    if(strstr(buffer,"CONNECT")!=(char *)NULL)
    {
        return (READ_CONNECT);
    }
    if(strstr(buffer,"END")!=(char*)NULL)
    {
        return (READ_END);
    }
    if ((strstr(buffer, "\nERROR") != (char *)NULL) || 
            (strstr(buffer, "\n+CME ERROR") != (char *)NULL)) {
        return (READ_ERROR);
    } /* endif */

    count = strlen(buffer);
    if (count > 0) {
        return(count);
    } /* endif */

    return(READ_NOTHING);
}

int pReadReply(int fd, char * buffer, int pBufLen)
{
    int lRes = -1;
    int lCount = 0;
    int lErrorCode;
    int i;

    do {
        lRes = pReadLine(fd, buffer, pBufLen);
        if ((lRes != READ_NOTHING) && (lRes != READ_EXCEPT)) {
            for (i=0; i<strlen(buffer); i++) {
                if ((buffer[i] == '\r') || (buffer[i] == '\n')) {
                    buffer[i] = ' ';
                } /* endif */
            } /* endfor */
            printf("< %d - [%d] - '%s'\n", lCount, lRes, buffer);
            if (lRes == READ_ERROR) {
                lErrorCode = pGetErrorCode(buffer);
                printf("<            Error code: %d\n", lErrorCode);
            } /* endif */
        } /* endif */
        lCount ++;
    } while ((lCount < 5) && (lRes != READ_OK) && (lRes != READ_ERROR) && (lRes != READ_EXCEPT)&&(lRes!=READ_CONNECT)&&(lRes!=READ_END));

    return(lRes);
}

void pClosePort(int fd)
{
    close(fd);
}

void printHelpInfo(char *argv[])
{
    printf("    function: send DFOTA package to UFS path of module via AT port\n");
    printf("    usage: %s -f DFOTA_package -p AT_port\n", argv[0]);
    printf("    DFOTA_package: regular file under any path\n");
    printf("    AT_port: device file under /dev, /dev/ttyUSB2 is useful in most cases\n");
}

mode_t getFileType(const char *filePath)
{
    struct stat fileStat;

    if (stat(filePath, &fileStat) == 0)
    {
        /* success */
        return fileStat.st_mode;
    }

    return S_IFMT;
}

char *getFileNameFromPath(char *filePath)
{
    char *p;

    p = strrchr(filePath, '/');
    if (p != NULL)
    {
        return p+1;  /* skip '/' */
    }

    return filePath;
}

void sendDataToPort(int port_fd, const char *buff, int send_num)
{
    int count;
    int written_sum = 0;

    while (1)
    {
        count = write(port_fd, &buff[written_sum], send_num - written_sum);
        if (count > 0)
        {
            written_sum += count;

            if (written_sum == send_num)
            {
                return;
            }
        }
        else
        {
            printf("write package failure, error:%s\n", strerror(errno));
        }

        printf("try to resend package in 1 second\n");
        sleep(1);
    }
}

int main(int argc,char *argv[])
{
    int opt,gFd;
    char fPath[256];
    char sPort[256];
    char *fName;
    char sCommand[128];
    char sBuffer[256];
    char txBuffer[QFUPL_TX_SIZE];
    long long int progress,size,iRe,nFileSize = 0;

    bzero(fPath,sizeof(fPath));
    bzero(sPort,sizeof(sPort));
    bzero(sCommand,sizeof(sCommand));
    bzero(sBuffer,sizeof(sBuffer));
    while((opt=getopt(argc,argv,"p:f:h"))!=-1)
    {
        switch(opt)
        {
            case 'f':
                if(!access(optarg,0)==0)
                {
                    printf("ERROR:File not found\n");
                    goto end;
                }
                memcpy(fPath,optarg,strlen(optarg));
                break;
            case 'p':
                if(!access(optarg,0)==0)
                {
                    printf("ERROR:Port not found\n");
                    goto end;
                }
                memcpy(sPort,optarg,strlen(optarg));
                break;
            case 'h':
                printHelpInfo(argv);
                exit(0);
        }
    }

    if(fPath[0]=='\0')
    {
        printf("ERROR:Missing file parameter\n");
        goto end;
    }
    if(sPort[0]=='\0')
    {
        //if the port is not specified, set /dev/ttyUSB2 as default.
        memcpy(sPort, "/dev/ttyUSB2",strlen("/dev/ttyUSB2"));
    }
    if (S_ISREG(getFileType(fPath)) == 0)
    {
        printf("ERROR:DFOTA package is not a regular file\n");
        goto end;
    }
    if (S_ISCHR(getFileType(sPort)) == 0)
    {
        printf("ERROR:AT port is not a character device file\n");
        goto end;
    }

    //get file size
    FILE* pFile = fopen(fPath,"rb");
    if(pFile==NULL)
    {
        printf("ERROR:Open file failed\n");
        goto end;
    }
    fseek(pFile,0,SEEK_END);
    size=ftell(pFile);
    fseek(pFile,0,SEEK_SET);

    //open port
    gFd=pOpenPort(sPort);
    if(gFd==-1)
    {
        printf("ERROR:Open port failed\n");
        goto end;
    }

    fName = getFileNameFromPath(fPath);

    sprintf(sCommand,"AT+QFDEL=\"UFS:%s\"", fName);
    pSendCommand(gFd,sCommand);
    bzero(sCommand,sizeof(sCommand));
    pReadReply(gFd,sBuffer,sizeof(sBuffer));

    sprintf(sCommand,"AT+QFUPL=\"UFS:%s\",%lld", fName, size);
    pSendCommand(gFd,sCommand);
    if(pReadReply(gFd,sBuffer,sizeof(sBuffer)) != READ_CONNECT)
    {
        printf("the response of QFUPL command is not \"CONNECT\"\n");
        goto end;
    }

    while(!feof(pFile))
    {
        if(nFileSize>=size)
            break;

        iRe= fread(&txBuffer,1,sizeof(txBuffer),pFile);
        nFileSize+=iRe;

        sendDataToPort(gFd, txBuffer, iRe);

        progress = nFileSize * 100 / size;
        if(progress==100)
        {
            printf( "progress : %lld%% finished\n", progress);
        }
        else
        {
            printf( "progress : %lld%% finished\r", progress);
        }

        usleep(5000);
    }
    pReadReply(gFd,sBuffer,sizeof(sBuffer));

    printf("file upload successfully!\n");

end:
    if (gFd != -1)
    {
        pClosePort(gFd);
    }

    if (pFile != NULL)
    {
        fclose(pFile);
    }


    return 0;
}
