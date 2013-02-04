
typedef enum{
    kUP=1,
    kDOWN,
    kLEFT,
    kRIGHT,
}DIRECTION;

// layer z
enum{
    zBgSpriteSheet,
    zBg,
    zCloud,
    zGameWorldMap,
    zPlatform,
    zParticleExplosion,
    zBirdSpriteSheet,
    zBird,
    zBonusSpriteSheet,
    zBonus,
    zBonusParticle,
    zTimerLablel,
    zButtonSpriteSheet,
    zBelowOperation,
    zPauseLayer,
    zAboveOperation,
    
};


//----tag
enum{
    tCancalEntity=100,
    tCorrectEntity,
    tGame,
    tPause,
    tNextLevel,
    tAudio,
    tAudioItem,
    tMusic,
    tMusicItem,
    tResume,
    tRestart,
    tPauseLayer,
    tOperationLayer,
    tShortestTime,
    tCurrentTime,
    
    tMazeSize,
    
};

typedef enum{
    tLayerPause=200,
    tLayerWin,
    tLayerLose,
    tLayerPrepare,
    tLayerNone,
}LayerType ;



#define _MY_AD_WHIRL_APPLICATION_KEY  @"9ad68ef5767447baa1dd37f4d7ae7766"


#define MIN_DISTANCE 10.0f
#define MIN_DISTANCE_PERCENT 0.5f

#define MENU_ANIM_SHOW_INTERVAL 0.5f

#define HAVE_SETTED @"HAVE_SETTED"

#define UDF_AUDIO @"UDF_AUDIO"
#define UDF_MUSIC @"UDF_MUSIC"
#define UDF_DIFFICULLY @"UDF_DIFFICULLY"
#define UDF_OPERATION @"UDF_OPERATION"
#define UDF_MAZESIZE @"UDF_MAZESIZE"
#define UDF_LEVEL_SELECTED @"UDF_LEVEL_SELECTED" //选择level，及当前正玩level
#define UDF_LEVEL_PASSED @"UDF_LEVEL_PASSED" //已通过最大level
#define UDF_LEVEL_CURRENT @"UDF_LEVELCURRENT" //当前正玩或刚刚结束level，先不用，以后或许会需要
#define UDF_TOTAL_SCORE @"UDF_TOTAL_SCORE" //用户积分

//FIXME release
#define kMAX_LEVEL_IDEAL 13
#define kMAX_LEVEL_REAL 13

#define MAX_AUTO_STEP 10

#define kGAME_INFO_LAST_TIME @"last time: %0.2f s  "
#define kGAME_INFO_CURRENT_TIME @"current time: %0.2f s"

#define kGAME_INFO_RESULT_WIN @"great! you are faster than last time"
#define kGAME_INFO_RESULT_LOSE @"ooh! you are slower than last time"

#define kPREPARE_TIME 1

#define kDEFAULT_LAST_TIME 1*60.0f

#define UFK_LAST_TIME @"UFK_LAST_TIME"


