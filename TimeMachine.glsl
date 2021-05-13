const float M_PI = 3.14159265358979323846264338327950288;
vec4 jDate;
float day() {
    float jDatex=jDate.x;
    float y366 = floor((jDatex-0.0)/400.0)+floor((jDatex-0.0)/4.0)-floor((jDatex-0.0)/100.0);
    float y365 = jDatex-y366;
    y366*=366.0; y365*=365.0;
    float d=y366+y365;
    if (jDate.y >= 0.0) d+=0.0;
    if (jDate.y >= 1.0) d+=31.0;
    if (jDate.y >= 2.0 && (int(mod(jDatex, 4.0))==0&&(int(mod(jDatex, 100.0))!=0||int(mod(jDatex, 400.0))==0))) d+=29.0;
    if (jDate.y >= 2.0 && (int(mod(jDatex, 4.0))!=0||int(mod(jDatex, 100.0))==0&&int(mod(jDatex, 400.0))!=0)) d+=28.0;
    if (jDate.y >= 3.0) d+=31.0;
    if (jDate.y >= 4.0) d+=30.0;
    if (jDate.y >= 5.0) d+=31.0;
    if (jDate.y >= 6.0) d+=30.0;
    if (jDate.y >= 7.0) d+=31.0;
    if (jDate.y >= 8.0) d+=31.0;
    if (jDate.y >= 9.0) d+=30.0;
    if (jDate.y >= 10.0) d+=31.0;
    if (jDate.y >= 11.0) d+=30.0;
    return mod(d+jDate.z-2.0, 7.0)+1.0;
}
vec4 bg(vec2 fragCoord) {//scene
    vec2 coord = (fragCoord)*4.0;
   	float t = (iTime);
    float x = float(coord.x)+64.0*sin((coord.x+coord.y)/60.0);
    float y = float(coord.y)+64.0*cos((coord.x-coord.y)/60.0);
    float r = float(x*x*t + y*y*t);
    vec4 fragColor = vec4(
        cos(sqrt(r)/x),
        cos(sqrt(r)/sqrt(t)),
        cos(sqrt(r)/y),
        sin(y/x)
    );
    fragColor.x+=(tan((degrees(atan(x, y))*1.0-t*2.0)))/4.0;
    fragColor.y+=(tan((degrees(atan(x, y))*1.0-t*2.0)))/4.0;
    fragColor.z+=(tan((degrees(atan(x, y))*1.0-t*2.0)))/4.0;
    return fragColor;
}
vec4 f(float x, float y, float t) {float N=iResolution.y/360.0;//clock zoom 
    float angle=atan(-x, -y);
    vec4 res = vec4(1.0, 1.0, 1.0, 1.0);//clock color
    vec4 years = vec4(0.2, 0.2, 0.2, 1.0);//years controller
    if ((x*x+y*y)<=150.0*150.0*N&&(x*x+y*y)>=146.0*146.0*N)//shadow
        return vec4(0.92,0.92,0.92,1.0);//shadow
    float jDatex = mod(jDate.x,10000.0);
    float jDate1 = 0.0; float jDate2 = 0.0;// 4 digits year
    if (jDate.x>99999.0) {//if year is 6 digits
        jDate2 = floor(jDate.x/100000.0);
        jDate1 = mod(jDatex,10000.0)/1000.0;
    }
    else if (jDate.x>9999.0) {//if year is 5 digits
        jDate2 = floor(jDate.x/100000.0);
        jDate1 = floor(jDate.x/10000.0);
    }
    if ((x*x+y*y)<=145.0*145.0*N&&(x*x+y*y)>140.0*140.0*N) {//140-145 radius
      if (degrees(angle)>-180.0&&degrees(angle)<=-180.0+6.0*(floor(jDate2)))
          return years;//100000
      if (degrees(angle)>-120.0&&degrees(angle)<=-120.0+6.0*(floor(jDate1)))
          return years;//10000
      if (degrees(angle)>-60.0&&degrees(angle)<=-60.0+6.0*(floor(jDatex/1000.0)))
          return years;//millenium of year
      if (degrees(angle)>0.0&&(degrees((angle)))<=6.0*(floor(mod(jDatex, 1000.0)/100.0)))
          return years;//century of year
      if (degrees(angle)>60.0&&degrees(angle)<=60.0+6.0*(floor(mod(jDatex,100.0)/10.0)))
         return years;//dacade of year
      if (degrees(angle)>120.0&&degrees(angle)<=(120.0+6.0*(floor(mod(jDatex,10.0)))))
          return years;//last num of year
    }

    if ((x*x+y*y)<145.0*145.0*N&&(x*x+y*y)>=135.0*135.0*N)//135-145 radius
      if (180.0+degrees(angle)<30.0*(jDate.y+1.0)&&180.0+degrees(angle)>30.0*(jDate.y+1.0)-6.0*day())
        return vec4(1.0,0.7,0.1,1.0);//day of week yellow color (month, day)
    
    if ((x*x+y*y)<145.0*145.0*N&&(x*x+y*y)>=135.0*135.0*N)//135-145 radius
      if (180.0+degrees(angle)>30.0*(jDate.y+1.0)&&180.0+degrees(angle)<30.0*(jDate.y+1.0)+6.0*jDate.z)
        return vec4(0.25,0.75,0.25,1.0);//date green color (month, day)
       
     if (x*x+y*y<=20.0*20.0*N)//10 radius
        return vec4(1.0,1.0,1.0, 1.0);
    if ((x*x+y*y)<=90.0*90.0*N)//90 radius
      if (int(ceil(60.0*angle/2.0/M_PI))==-int(floor(30.0-mod(((t+0.001)/60.0/12.0),60.0))))
        return vec4(0.0,0.0,0.0,1.0); //hours arrow color
    if ((x*x+y*y)<=110.0*110.0*N)//115 radius
      if (int(ceil(60.0*angle/2.0/M_PI))==-int(floor(30.0-mod(((t+0.001)/60.0), 60.0))))
        return vec4(0.0,0.8,0.8,1.0);//minutes arrow color
    if ((x*x+y*y)<=135.0*135.0*N)//140 radius
      if (int((ceil(60.0*angle/2.0/M_PI)))==-int(floor(30.0-mod(((t+0.001)),60.0))))
        return vec4(1.0,0.0,0.6,1.0);//seconds arrow color
    if ((x*x+y*y)<=150.0*150.0*N)//150 radius
        return res;//clock color
   
    if ((x*x+y*y)<=170.0*170.0*N) {//170 radius
        float dt = 0.0; float jDatew = t;
        if(mod(floor(jDatew/3600.0), 24.0)>=12.0) dt=1.0;// dt sets PM/AM
        res.x=float(int(mod(floor(60.0*radians((degrees(angle))-mod(floor(jDatew/3600.0)+dt, 24.0)*30.0)/2.0/M_PI),2.0)));
        res.y=float(int(mod(floor(60.0*radians((degrees(angle))-mod(floor(jDatew/3600.0)+dt, 24.0)*30.0)/2.0/M_PI/5.0),2.0)));
        res.z=(res.x+res.y)/abs(2.0-mod(t, 4.0));//clock segmentation animate by t(time)
        return abs(res);//color for clock segmentation
    }
    else {
        res = (vec4(0.0,0.2,0.2,1.0)*sin((y-535.0)/340.0)*sin((x-1070.0)/680.0));//old background
        if(abs(y)<10000.0)res = bg(vec2(x,y))/1.0;//new scene
        return res;
    }
    
}
void mainImage( out vec4 fragColor, in vec2 fragCoord ) {float N=iResolution.y/360.0;
    
    jDate = iDate; // 4D TIME POINT 
    // You can fix it to display any date and any time of 1 million years.
    
    vec2 coord = fragCoord - (iResolution.xy / vec2(2.0));//simmetric
    float dx = iMouse.x-iResolution.x/2.0;//mouse move x
    float dy = iMouse.y-iResolution.y/2.0;//mouse move y
    if(dx!=-iResolution.x/2.0||dy!=-iResolution.y/2.0)
    { coord.x+=dx; coord.y+=dy; }//move graphics x, y
    fragColor= f(coord.x,coord.y,float(jDate.w)); //go
    if (coord.x*coord.x+coord.y*coord.y>170.0*170.0*N){//shadow
        if (coord.x*coord.x+coord.y*coord.y<180.0*180.0*N)//shadow
            fragColor/=8.0;//shadow
     }
    if (coord.x*coord.x+coord.y*coord.y<=145.0*145.0*N)//arrows texture animate
        fragColor+=abs(tan(abs(degrees(atan(coord.x, coord.y))*4.0-jDate.w*2.0)))/16.0;
}
