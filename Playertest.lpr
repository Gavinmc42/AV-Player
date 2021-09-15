program Playertest;

{$mode objfpc}{$H+}

{ Raspberry Pi Zero Application                                                }
{  Add your program code below, add additional units to the "uses" section if  }
{  required and create new units by selecting File, New Unit from the menu.    }
{                                                                              }
{  To compile your program select Run, Compile (or Run, Build) from the menu.  }

uses
  RaspberryPi,
  GlobalConfig,
  GlobalConst,
  GlobalTypes,
  Platform,
  Threads,
  OpenVG,
  VC4,
  SysUtils,
  Syscalls,
  Classes,
  Console,
  Framebuffer,
  Player,
  VGlayers,
  pushdash,
  dispmanx,
  UltiboUtils,  {Include Ultibo utils for some command line manipulation}
  Ultibo
  { Add additional units here };

var
  Console1: TWindowHandle;
  AudioThread: TAudioThread;
  VideoThread: TVideoThread;
  DefFrameBuff : PFrameBufferDevice;
  Properties : TWindowProperties;
  Width: Integer;
  Height: Integer;
  SpacingX, SpacingY: Integer;

  Watts, KPH, Volts, Amps :VGfloat;

 procedure WaitForSDDrive;
  begin
    while not DirectoryExists('C:\') do
      sleep(500);
  end;

begin
  { Add your program code here }
  begin

  Console1 := ConsoleWindowCreate(ConsoleDeviceGetDefault, CONSOLE_POSITION_FULLSCREEN, True);

  ConsoleWindowWriteLn(Console1, 'Audio / Video Test using OpenMax (OMX) with OpenVG overlays.');

  DefFrameBuff := FramebufferDeviceGetDefault;
  Width := 1920;
  Height := 1080;

  WaitForSDDrive;

  VGShapesSetLayer(2);
  {Initialize OpenVG and the VGShapes unit}
  VGShapesInit(Width, Height);
  VGShapesWindowOpacity(128);
  {Start a picture the full width and height of the screen}
  VGShapesStart(Width, Height);

  SpacingX := 320;
  SpacingY := 240;

  VGShapesBackgroundRGB(0,0,0, 0.0);

  AudioThread := TAudioThread.Create('C:\push.wav', True);
  VideoThread := TVideoThread.Create('C:\output.h264', True);

  // Start audio thread (Video thread starts immediately)
  AudioThread.Start;

  Volts := 12.6;
  KPH := 31;
  Watts := 245;
  Amps := 16.7;

  while True do

    begin
      VGShapesWindowClear;
      pushspeedo( 'Volts', 960 - 520, SpacingY,240, 20, 5);
      pushspeedo( 'KPH', 960 - 200, SpacingY,360, 60, 10);
      pushspeedo( 'Watts',960 + 200, SpacingY,360, 600, 100);
      pushspeedo( 'Amps', 960 + 520, SpacingY,240, 30, 5);
      pushneedle(960 - 520,SpacingY,240, 20, Volts);
      pushneedle(960 - 200,SpacingY,360, 60, KPH);
      pushneedle(960 + 200,SpacingY,360, 600, Watts);
      pushneedle(960 + 520,SpacingY,240, 30, Amps);

      {End our picture and render it to the screen}
      VGShapesEnd;
      sleep(500);
      KPH := KPH + Random(5) - 2.5;
   end;

   {VGShapes calls BCMHostInit during initialization, we should also call BCMHostDeinit to cleanup}
  BCMHostDeinit;

  ConsoleWindowWriteLn(Console1, 'Halted.');
  ThreadHalt(0);

  end;

end.

