


#import <Foundation/Foundation.h>
#import <AVFoundation/AVFAudio.h>
#import <unistd.h>
#import <stdio.h>
#import <stdlib.h>

#define min(a,b) ((a)<(b)?(a):(b))
#define max(a,b) ((a)>(b)?(a):(b))

int main(int argc,char **argv){
    //default path for easy testing CHANGE THIS
    char *path="/Users/apple1/sound/mark/jizzy.mp3";


    //if no arguments are passed, display a usage message
    if(argc==1){
        printf("Usage: \n");
        printf("\t-v <volume> \n");
        printf("\t-s <speed> \n");
        printf("\t-t <start time> \n");
        printf("Example: play song.mp3 with volume .5 at double speed, starting 1 second in \n");
        printf("\t./musicplayer /path/to/song.mp3 -v .5 -s 2 -t 1 \n");
    }

    //command line options are option so we need default values
    float speed=1.0;
    float volume=1.0;
    double start=1e-10;
    //true if the previous argument was a switch (-s,-v,-t)
    bool tak_s=false,tak_v=false,tak_t=false;
    for(int i=1;i<argc;i++){
        char *arg=argv[i];
        if      (strcmp(arg,"-s")==0){
            tak_s=true;
        }else if(strcmp(arg,"-v")==0){
            tak_v=true;
        }else if(strcmp(arg,"-t")==0){
            tak_t=true;
        }else{
            if      (tak_s){
                speed=atof(arg);
            }else if(tak_v){
                volume=max(min(atof(arg),1.0),0.0);//volume clamped between 0 and 1
            }else if(tak_t){
                start=atof(arg);
            }else{
                path=arg;
            }
            tak_v=false;
            tak_s=false;
            tak_t=false;
        }
    }

    NSString *nspath=[[NSString alloc] initWithUTF8String:path];
    NSURL *url=[NSURL fileURLWithPath:nspath];
    AVAudioPlayer *player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

    player.numberOfLoops=0;  //play the song exactaly once
    player.enableRate=true;
    player.rate=speed;
    player.volume=volume;
    player.currentTime=start;
    [player play]; //asynchronus: audio played in a separate thread

    //wait for the player thread to finish before exiting the main thread
    //we could just sleep for player.duration but this program is meant to
    //be paused and played with unix signals
    do{
        sleep(1);  //go to sleep for 1 second
    }while(player.currentTime != 0.0);      //when currentTime==0 the song is finished


}





