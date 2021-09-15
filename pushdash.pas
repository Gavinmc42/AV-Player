unit pushdash;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  OpenVG,       {Include the OpenVG unit so we can use the various types and structures}
  VGShapes,     {Include the VGShapes unit to give us access to all the functions}
  VC4;


var

Width:Integer;  {A few variables used by our shapes example}
Height:Integer;


procedure pushspeedo(title:string;x,y,r, maxscale, divtick:Integer) ;

procedure pushneedle(x,y,r,  maxscale:Integer; Speed:VGfloat) ;

implementation

procedure pushneedle(x,y,r, maxscale:Integer; Speed:VGfloat) ;
   var
       Needle:VGfloat;
       knots:Integer;
       code:Integer;
       Dial:VGfloat;
       Steps :VGfloat;

   begin
       Dial:= r * 1.0;
       Needle:= r / 2 * 0.90;
       Steps := 300 / maxscale ;

       VGShapesTranslate(x,y);

       //rotate to the Zero point
       VGShapesRotate(-210);


       VGShapesRotate(Speed * -Steps);
       VGShapesStrokeWidth(Dial * 0.025);
       VGShapesStroke(255,0,0,1);
       VGShapesFill(255,0,0,1);
       VGShapesLine(0,0, 0,Needle);
       VGShapesRotate(Speed * Steps);

       //return to zero rotation
       VGShapesRotate(210);

       //reset back to zero position
       VGShapesTranslate(-x,-y);

   end;

    procedure pushspeedo(title:string;x,y,r, maxscale, divtick:Integer );
    var
       Ticks, Subticks:Integer;
       //PosDeg:VGfloat;
       PosNum:VGfloat;
       PosT1:VGfloat;
       PosT2:VGfloat;
       PosT3:VGfloat;
       Dial:VGfloat;
       KPH: string;
       Steps :VGfloat;
       Count, Fontsize:Integer;

     begin

       //val(gpsknots,knots, code);
       //convert to KPH
       //Speed := 100 * knots div 54;

       VGShapesTranslate(x,y);
       PosT1:= r / 2 * 0.95;
       PosT2:= r / 2 * 0.88;
       PosT3:= r / 2 * 0.84;

       PosNum:= r / 2 * 0.64;
       //Needle:= r / 2 * 0.92;
       Dial:= r * 1.0;



       Fontsize:=Trunc(Dial * 0.1);

       VGShapesStrokeWidth(Dial * 0.005);
       VGShapesStroke(80,255,128,1);
       VGShapesFill(80,255,128,1);

       VGShapesTextMid(0, - Dial * 0.20, title,VGShapesSerifTypeface,Fontsize);

       //rotate to the Zero point
       VGShapesRotate(-210);

       count := 0;
       Fontsize:=Trunc(Dial * 0.08);

       if maxscale < 120 then
           begin
           Steps := 300 / maxscale ;
           for Ticks := 0 to maxscale do
               Begin
                    if Ticks mod divtick = 0 then
                      Begin
                        KPH := IntToStr(Ticks);
                        VGShapesStrokeWidth(Dial * 0.01);
                        VGShapesTextMid(0,PosNum,KPH,VGShapesSansTypeface,Fontsize);
                        VGShapesLine(0,PosT1, 0,PosT3);
                      end

                    else
                        begin
                        VGShapesStrokeWidth(Dial * 0.002);
                        VGShapesLine(0,PosT1, 0,PosT2);
                        end;

                VGShapesRotate(-Steps);
                inc(count);
               end;

           end
        else
            begin
            Steps := 5 ;
            Subticks := maxscale div 10;
            for Ticks := 0 to Subticks do
                begin

                      if Ticks mod 10 = 0 then
                          Begin
                            KPH := IntToStr(Ticks * 10);
                            VGShapesStrokeWidth(Dial * 0.01);
                            VGShapesTextMid(0,PosNum,KPH,VGShapesSansTypeface,Fontsize);
                            VGShapesLine(0,PosT1, 0,PosT3);
                          end

                      else
                          begin
                            VGShapesStrokeWidth(Dial * 0.002);
                            VGShapesLine(0,PosT1, 0,PosT2);
                          end;

                 VGShapesRotate(-Steps);
                 inc(count);

                end;
         end;

       // rotate back to zero point
       VGShapesRotate( count * Steps);

       VGShapesStroke(0,0,0,1);
       VGShapesFill(255,0,0,1);
       VGShapesCircle(0,0,Dial * 0.12);

       //return to zero rotation
       VGShapesRotate(210);

       //reset back to zero position
       VGShapesTranslate(-x,-y);


  end;

end.

