#include <iostream>
#include <stdio.h>
#include <string.h>
#include <string>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>

#include "proto/message.piqi.pb.h"

using namespace std;

/**
    TCP Client class
*/
class tcp_client
{
private:
    int sock;
    std::string address;
    int port;
    struct sockaddr_in server;

public:
    tcp_client();
    bool conn(string, int);
    bool send_data(void *date, int len);
    string receive(int);
};

tcp_client::tcp_client()
{
    sock = -1;
    port = 0;
    address = "";
}

/**
    Connect to a host on a certain port number
*/
bool tcp_client::conn(string address , int port)
{
    //create socket if it is not already created
    if(sock == -1)
    {
        //Create socket
        sock = socket(AF_INET , SOCK_STREAM , 0);
        if (sock == -1)
        {
            perror("Could not create socket");
        }

        cout<<"Socket created\n";
    }
    else    {   /* OK , nothing */  }

    //setup address structure
    if(inet_addr(address.c_str()) == -1)
    {
        struct hostent *he;
        struct in_addr **addr_list;

        //resolve the hostname, its not an ip address
        if ( (he = gethostbyname( address.c_str() ) ) == NULL)
        {
            //gethostbyname failed
            herror("gethostbyname");
            cout<<"Failed to resolve hostname\n";

            return false;
        }

        //Cast the h_addr_list to in_addr , since h_addr_list also has the ip address in long format only
        addr_list = (struct in_addr **) he->h_addr_list;

        for(int i = 0; addr_list[i] != NULL; i++)
        {
            //strcpy(ip , inet_ntoa(*addr_list[i]) );
            server.sin_addr = *addr_list[i];

            cout<<address<<" resolved to "<<inet_ntoa(*addr_list[i])<<endl;

            break;
        }
    }

    //plain ip address
    else
    {
        server.sin_addr.s_addr = inet_addr( address.c_str() );
    }

    server.sin_family = AF_INET;
    server.sin_port = htons( port );

    //Connect to remote server
    if (connect(sock , (struct sockaddr *)&server , sizeof(server)) < 0)
    {
        perror("connect failed. Error");
        return 1;
    }

    cout<<"Connected\n";
    return true;
}

/**
    Send data to the connected host
*/
bool tcp_client::send_data(void *data, int len)
{
    //Send some data
    if( send(sock , data , len , 0) < 0)
    {
        perror("Send failed : ");
        return false;
    }

    return true;
}

/**
    Receive data from the connected host
*/
string tcp_client::receive(int size=512)
{
    char buffer[size];
    string reply;

    //Receive a reply from the server
    if( recv(sock , buffer , sizeof(buffer) , 0) < 0)
    {
        puts("recv failed");
    }

    reply = buffer;
    return reply;
}

void
loop(tcp_client &client)
{
    GOOGLE_PROTOBUF_VERIFY_VERSION;
    string outputMessage;
    string inputMessage;
    message_proto::message message;
    int i;

    for (i = 0; i < 24; i++) {
        string m = "A";
        m[0] += i;

        message.Clear();
        message.set_id(1);
        message.set_msg(m);
        message.set_type(message_proto::request);
        message.SerializeToString(&outputMessage);


        // send message
        cout << "S: " << message.id() << "; " << message.msg() << "; " <<
            ((message.type() == message_proto::request) ? "request" : "response") << endl;

        client.send_data((void *) (outputMessage.c_str()), outputMessage.length());

        // receive answer
        message.Clear();
        message.ParseFromString(client.receive(1024));
        cout << "R: " << message.id() << "; " << message.msg() << "; " <<
            ((message.type() == message_proto::request) ? "request" : "response") << endl;

        sleep(1);
    }

}

int main(int argc , char *argv[])
{
    tcp_client c;
    const char *host;

    host = "localhost";
    c.conn(host , 1234);

    loop(c);

    return 0;
}
