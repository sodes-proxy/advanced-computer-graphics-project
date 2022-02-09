/**
* This method is used to rotate the uv provided
* @param p uv to be rotated
* @param pivot  pivot of rotation
* @param a  angle of rotation
* @return p uv rotated
**/
float2 rotation(float2 p,float2 pivot,float a){
    float y=sin(a);
    float x=cos(a);
    p-=pivot;
    p=float2(p.x*x-p.y*y,p.x*y+p.y*x);
    p+=pivot;
    //rot=p;
    return p;
}
/**
* This method provides the main functionality of a mandelbrot set
* @param MaxIterations Maximum number of iterations
* @param Area  area of the mandelbrot set (used to move around and zooming in)
* @param Symmetry used to create the kaleidoscope effect
* @param angle angle of rotation of the set
* @return finalIteration iteration where the condition was met
* @return finalPixelPos position of the mandelbrot set
* @return finalFracIter Used for making an interpolation and give a smooth effect
**/
void mandelbrot_float(in float MaxIterations,in float4 Area,float2 textcoord,in float Symmetry,in float angle, out float finalIteration, out float2 finalPixelPos,out float finalFracIter){
    //kaleidoscope like effect
    float2 uv=textcoord-.5;
    uv=abs(uv);
    uv=rotation(uv,0,.25*3.1416);
    uv=abs(uv);
    uv=lerp(textcoord-.5,uv,Symmetry);
    float2 startPos=Area.xy+ uv*Area.zw;
    startPos=rotation(startPos,Area.xy,angle); 
    float escapeR=20; //escape radius
    float escapeR2=escapeR*escapeR;
    float2 pixelPos,pixelPosPrevious;
    float iteration;
    for (iteration =0;iteration<MaxIterations;iteration++){
        pixelPosPrevious=rotation(pixelPos,0,_Time.y);
        pixelPos=float2(pixelPos.x*pixelPos.x-pixelPos.y*pixelPos.y,2*pixelPos.x*pixelPos.y) + startPos;
        if(dot(pixelPos,pixelPosPrevious)>escapeR2){
            break;
        }
    }
    float distance=length(pixelPos);//distance from origin
    float fracIter=log2(log(distance)/log(escapeR));//double exponential interpolation
    finalIteration=iteration;
    finalPixelPos=pixelPos;
    finalFracIter=fracIter;
}
/**
* Generates a pseudorandom number, it is used to randomize the water drops
* @param p seed
* @return random number from 0 to 1
**/
float random(float2 p){
    p=frac(p*float2(123.34,345.45));
    p+= dot(p,p+34.345);
    return frac(p.x*p.y);
}
/**
* This method is used to create the main rainy window functionality
* @param textcoord are the uv of the texture
* @param T  time value to be added (allows for easier debugging, by advancing time)
* @param distortion is the drop distortion, how much the image is affected
* @param size determines the grid size (bigger value, more drops and smaller)
* @param blur determines how blurry the image can get
* @return finalCol color value
* @return finalUV uv value
**/
void rainyWindow_float(in float2 textcoord,in float T,in float distortion,in float size,in float blur,out float4 finalCol,out float2 finalUV){
    float t=fmod(_Time.y+T,7200);
    float4 col=0;
    float2 aspect=float2(2,1);
    float2 uv=textcoord*size*aspect;
    uv.y+=t*.25;
    float2 gv= frac(uv)-.5;
    float2 id=floor(uv);
    
    float noise=random(id);
    t+=noise*6.2831;

    float w=textcoord.y*10;
    float x=(noise-.5)*8; //-.4 .4
    x+=(.4-abs(x))*sin(3*w)*pow(sin(w),6)*.45;
    float y=-sin(t+sin(t+sin(t)*.5))*.45;
    y-=(gv.x-x)*(gv.x-x);
    //waterDrop
    float2 dropPos=(gv-float2(x,y))/aspect;
    float drop =smoothstep(.05,.03,length(dropPos));
    //drop trail
    float2 trailPos=(gv-float2(x,t*.25))/aspect;
    trailPos.y=(frac(trailPos.y*8)-.5)/8;
    float trail =smoothstep(.03,.01,length(trailPos));
    float fogTrail=smoothstep(-.05,.05,dropPos.y);
    fogTrail*=smoothstep(.5,y,gv.y);

    trail*=fogTrail;
    fogTrail*=smoothstep(.05,.04,abs(dropPos.x));

    col+=fogTrail*.5;
    col+=trail;
    col+=drop;
    float2 offs=drop*dropPos+trail*trailPos;
    finalCol=col;
    finalUV=textcoord+offs*distortion;
    //return col;
}