Shader "Fruit"
{
      Properties
      {
            _TextureChannel0 ("Texture", 2D) = "gray" {}
            _TextureChannel1 ("Texture", 2D) = "gray" {}
            _TextureChannel2 ("Texture", 2D) = "gray" {}
            _TextureChannel3 ("Texture", 2D) = "gray" {}


      }
      SubShader
      {
            Tags { "RenderType"="Transparent" "Queue" = "Transparent" "DisableBatching" ="true" }
            LOD 100

            Pass
            {
                ZWrite Off
                Cull off
                Blend SrcAlpha OneMinusSrcAlpha
                
                  CGPROGRAM
                  #pragma vertex vert
                  #pragma fragment frag
                  
                  #pragma multi_compile_instancing
                  
                  #include "UnityCG.cginc"

                  struct vertexPoints
                  {
                        float4 vertex : POSITION;
                        float2 uv : TEXCOORD0;
                  UNITY_VERTEX_INPUT_INSTANCE_ID
                  };

                  struct pixel
                  {
                        float2 uv : TEXCOORD0;
                        float4 vertex : SV_POSITION;
                        UNITY_VERTEX_INPUT_INSTANCE_ID
                  };

                  UNITY_INSTANCING_BUFFER_START(CommonProps)
                  UNITY_DEFINE_INSTANCED_PROP(fixed4, _FillColor)
                  UNITY_DEFINE_INSTANCED_PROP(float, _AASmoothing)
                  UNITY_DEFINE_INSTANCED_PROP(float, _rangeZero_Ten)
                  UNITY_DEFINE_INSTANCED_PROP(float, _rangeSOne_One)
                  UNITY_DEFINE_INSTANCED_PROP(float, _rangeZoro_OneH)
                  UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_x)
                  UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_y)

                  UNITY_INSTANCING_BUFFER_END(CommonProps)

            

                  pixel vert (vertexPoints v)
                  {
                        pixel o;
                        
                        UNITY_SETUP_INSTANCE_ID(v);
                        UNITY_TRANSFER_INSTANCE_ID(v, o);
                        
                        o.vertex = UnityObjectToClipPos(v.vertex);
                        o.uv = v.vertex.xy;
                        return o;
                  }
            
                  sampler2D _TextureChannel0;
                  sampler2D _TextureChannel1;
                  sampler2D _TextureChannel2;
                  sampler2D _TextureChannel3;
                  
                  float2 mouseCoordinateFunc(float x, float y)
                  {
                        return normalize(float2(x,y));
                  }


                  #define PI 3.1415927
                  #define TIME _Time.y
      
                  const float3x3 m = { 0.00,  0.80,  0.60,
                                      -0.80,  0.36, -0.48,
                                      -0.60, -0.48,  0.64 };
                  
                  float hash( float n )
                  {
                      return frac(sin(n)*4121.15393);
                  }
                  
                  float noise( in float3 x )
                  {
                        float3 p = floor(x);
                        float3 f = frac(x);
                          
                        f = f*f*(3.0-2.0*f);
                    
                        float n = p.x + p.y*157.0 + 113.0*p.z;
                    
                        return lerp(lerp(lerp( hash(n+  0.0), hash(n+  1.0),f.x),
                                    lerp( hash(n+157.0), hash(n+158.0),f.x),f.y),
                                    lerp(lerp( hash(n+113.0), hash(n+114.0),f.x),
                                    lerp( hash(n+270.0), hash(n+271.0),f.x),f.y),f.z);
                  }
                  
                  float fbm( float3 p )
                  {
                      float f = 0.0;
                  
                      f += 0.5000*noise( p ); 
                      p = mul(m,p*2.02);
                      f += 0.2500*noise( p ); 
                      p = mul(m,p*2.03);
                      f += 0.1250*noise( p ); 
                      p = mul(m,p*2.01);
                      f += 0.0625*noise( p );
                  
                      return f/0.9375;
                  }
                  
                  //=======================================================================
                  
                  float2 map( float3 p )
                  {
                      // table
                      float2 d2 = float2( p.y+0.55, 2.0 );
                  
                      // apple
                      p.y -= 0.75*pow(dot(p.xz,p.xz),0.2);
                      float2 d1 = float2( length(p) - 1.0, 1.0 );
                  
                      // union    
                      return (d2.x<d1.x) ? d2 : d1; 
                  }
                  
                  float3 appleColor( in float3 pos, in float3 nor, out float2 spe )
                  {
                      spe.x = 1.0;
                      spe.y = 1.0;
                  
                      float a = atan2(pos.x,pos.z);
                      float r = length(pos.xz);
                  
                      // red
                      float3 col = float3(1.0,0.0,0.0);
                  
                      // green
                      float f = smoothstep( 0.4, 1.0, fbm(pos*1.0) );
                      col = lerp( col, float3(0.9,0.9,0.2), f );
                  
                      // dirty
                      f = smoothstep( 0.0, 1.0, fbm(pos*4.0) );
                      col *= 0.8+0.2*f;
                  
                      // frekles
                      f = smoothstep( 0.0, 1.0, fbm(pos*48.0) );
                      f = smoothstep( 0.6,1.0,f);
                      col = lerp( col, float3(0.9,0.9,0.6), f*0.4 );
                  
                      // stripes
                      f = fbm( float3(a*7.0 + pos.z,3.0*pos.y,pos.x)*2.0);
                      f = smoothstep( 0.2,1.0,f);
                      f *= smoothstep(0.4,1.2,pos.y + 0.75*(noise(4.0*pos.zyx)-0.5) );
                      col = lerp( col, float3(0.4,0.2,0.0), 0.5*f );
                      spe.x *= 1.0-0.35*f;
                      spe.y = 1.0-0.5*f;
                  
                      // top
                      f = 1.0-smoothstep( 0.14, 0.2, r );
                      col = lerp( col, float3(0.6,0.6,0.5), f );
                      spe.x *= 1.0-f;
                  
                  
                      float ao = 0.5 + 0.5*nor.y;
                      col *= ao*1.2;
                  
                      return col;
                  }
                  
                  float3 floorColor( in float3 pos, in float3 nor, out float2 spe )
                  {
                      spe.x = 1.0;
                      spe.y = 1.0;
                      float3 col = float3(0.5,0.4,0.3)*1.7;
                  
                      float f = fbm( 4.0*pos*float3(6.0,0.0,0.5) );
                      col = lerp( col, float3(0.3,0.2,0.1)*1.7, f );
                      spe.y = 1.0 + 4.0*f;
                  
                      f = fbm( 2.0*pos );
                      col *= 0.7+0.3*f;
                  
                      // frekles
                      f = smoothstep( 0.0, 1.0, fbm(pos*48.0) );
                      f = smoothstep( 0.7,0.9,f);
                      col = lerp(col, float3(0.2, 0.2, 0.2), f * 0.75);
                  
                      // fake ao
                      f = smoothstep( 0.1, 1.55, length(pos.xz) );
                      col *= f*f*1.4;
                      col.x += 0.1*(1.0-f);
                      return col;
                  }
                  
                  float2 intersect( in float3 ro, in float3 rd )
                  {
                      float t=0.0;
                      float dt = 0.06;
                      float nh = 0.0;
                      float lh = 0.0;
                      float lm = -1.0;
                      for(int i=0;i<128;i++)
                      {
                              float2 ma = map(ro+rd*t);
                              nh = ma.x;
                              if(nh>0.0) 
                              { 
                                    lh=nh; 
                                    t+=dt;  
                              } 
                              lm=ma.y;
                      }
                  
                      if( nh>0.0 ) return float2(-1.0, -1.0);
                      t = t - dt*nh/(nh-lh);
                  
                      return float2(t,lm);
                  }
                  
                  float softshadow( in float3 ro, in float3 rd, float mint, float maxt, float k )
                  {
                      float res = 1.0;
                      float dt = 0.1;
                      float t = mint;
                      for( int i=0; i<30; i++ )
                      {
                          float h = map(ro + rd*t).x;
                          h = max(h,0.0);
                          res = min( res, smoothstep(0.0,1.0,k*h/t) );
                          t += dt;
                              if( h<0.001 ) break;
                      }
                      return res;
                  }
                  
                  float3 calcNormal( in float3 pos )
                  {
                        float2 eps = float2(.001,0.0);
                        return normalize( float3(map(pos+eps.xyy).x - map(pos-eps.xyy).x,
                                             map(pos+eps.yxy).x - map(pos-eps.yxy).x,
                                             map(pos+eps.yyx).x - map(pos-eps.yyx).x ) );
                  }

                  #define AA 2

                  fixed4 frag (pixel i) : SV_Target
                  {
                              
                        //////////////////////////////////////////////////////////////////////////////////////////////
                        ///   DEFAULT
                        //////////////////////////////////////////////////////////////////////////////////////////////
      
                        UNITY_SETUP_INSTANCE_ID(i);
                              
                        float aaSmoothing = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _AASmoothing);
                        fixed4 fillColor = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _FillColor);
                        float _rangeZero_Ten = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZero_Ten);
                        float _rangeSOne_One = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeSOne_One);
                        float _rangeZoro_OneH = UNITY_ACCESS_INSTANCED_PROP(CommonProps,_rangeZoro_OneH);
                        float _mousePosition_x = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_x);
                        float _mousePosition_y = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_y);
            
                        float2 mouseCoordinate = mouseCoordinateFunc(_mousePosition_x, _mousePosition_y);
            
                        float2 scaleResolution = i.uv + 1;
                              
                        float2 coordinateScale = scaleResolution.xy/float2(2, 2);
                                  
                        float2 coordinate = i.uv;
            
                        //Test Output 
                        float3 col = float3(coordinate.x + coordinate.y, coordinate.y - coordinate.x, pow(coordinate.x,2.0f));
                        //////////////////////////////////////////////////////////////////////////////////////////////
                        ///   DEFAULT
                        //////////////////////////////////////////////////////////////////////////////////////////////
                  
                        col = 0.0;
                        //////////////////////////////////////////////////////////////////////////////////////////////
                        // vec2 q = fragCoord.xy / iResolution.xy;
                        // vec2 p = -1.0 + 2.0 * q;
                        // p.x *= iResolution.x/iResolution.y;
                    
                        // camera
                        float2 p = coordinate;
                        float2 q = coordinateScale;
                        float iTime = TIME;
                        float3 ro = 2.5*normalize(float3(cos(0.2*iTime),0.9+0.3*cos(iTime*.11),
                                                                      sin(0.2*iTime)));
                        float3 ww = normalize(float3(0.0,0.5,0.0) - ro);
                        float3 uu = normalize(cross( float3(0.0,1.0,0.0), ww ));
                        float3 vv = normalize(cross(ww,uu));
                        float3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );
                    
                        // raymarch
                        col = float3(0.96,0.98,1.0);
                        float2 tmat = intersect(ro,rd);
                        if( tmat.y>0.5 )
                        {
                            // geometry
                            float3 pos = ro + tmat.x*rd;
                            float3 nor = calcNormal(pos);
                            float3 ref = reflect(rd,nor);
                            float3 lig = normalize(float3(1.0,0.8,-0.6));
                         
                            float con = 1.0;
                            float amb = 0.5 + 0.5*nor.y;
                            float dif = max(dot(nor,lig),0.0);
                            float bac = max(0.2 + 0.8*dot(nor,float3(-lig.x,lig.y,-lig.z)),0.0);
                            float rim = pow(1.0+dot(nor,rd),3.0);
                            float spe = pow(clamp(dot(lig,ref),0.0,1.0),16.0);
                    
                            // shadow
                            float sh = softshadow( pos, lig, 0.06, 4.0, 6.0 );
                    
                            // lights
                            col  = 0.10 * con * float3(0.80,0.90,1.00);
                            col += 0.70 * dif * float3(1.00,0.97,0.85) * float3(sh, (sh+sh*sh)*0.5, sh*sh );
                            col += 0.15 * bac * float3(1.00,0.97,0.85);
                            col += 0.50 * amb * float3(0.10,0.15,0.20);
                    
                            // color
                            float2 pro;
                            if( tmat.y<1.5 )
                            col *= appleColor(pos,nor,pro);
                            else
                            col *= floorColor(pos,nor,pro);
                    
                            // rim and spec
                            col += 0.70*rim*float3(1.0,0.9,0.8)*amb*amb*amb;
                            col += 0.60*pow(spe,pro.y)*float3(1.0,1.0,1.0)*pro.x*sh;
                    
                            // gamma
                            col = sqrt(col);
                        }
                    
                        // vignetting
                        col *= 0.25 + 0.75*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.15 );
            
            
                        return float4(col,1.0); 
      
                              
                  }

                  ENDCG
            }
      }
}

























