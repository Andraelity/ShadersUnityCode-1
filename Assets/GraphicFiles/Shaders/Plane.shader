Shader "Plane"
{
	Properties
	{
		_TextureChannel0 ("Texture", 2D) = "gray" {}
		_TextureChannel1 ("Texture", 2D) = "gray" {}
		_TextureChannel2 ("Texture", 2D) = "gray" {}
		_TextureChannel3 ("Texture", 2D) = "gray" {}

        _ExampleName ("Float with range", Range(0.0, 10)) = 0.5


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

   

			pixel vert (vertexPoints v)
			{
				pixel o;
				
				
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.vertex.xy;
				return o;
			}
            
                sampler2D _TextureChannel0;
                sampler2D _TextureChannel1;
                sampler2D _TextureChannel2;
                sampler2D _TextureChannel3;
      			
                float _ExampleName;
                #define PI 3.1415927
                #define TIME _Time.y

            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////




            #define AA 2
		


float2x2 m = { 0.80,  0.60,
              -0.60,  0.80 };

float hash( float n )
{
    return frac(sin(n)*43758.5453);
}

float noise( in float2 x )
{
    float2 p = floor(x);
    float2 f = frac(x);
    f = f*f*(3.0-2.0*f);
    float n = p.x + p.y*57.0;
    float res = lerp(lerp( hash(n+  0.0), hash(n+  1.0),f.x),
                     lerp( hash(n+ 57.0), hash(n+ 58.0),f.x),f.y);
    return -1.0 + 2.0*res;
}

float fbm4( float2 p )
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


void cell( in float2 li, inout float2 dmin, inout float3 info, in float2 ip, in float2 f )
{
    float nn = (ip.x+li.x) + 57.0*(ip.y+li.y) ;
    float2 di = li - f + float2(hash(nn), hash(nn+1217.0));
    float d2 = dot(di,di);
    if( d2<dmin.x )
    {
        info.xy = di;
        info.z = nn;
        dmin.y = dmin.x;
        dmin.x = d2;
    }
    else if( d2<dmin.y )
    {
        dmin.y = d2;
    }
}

float2 celular( in float2 x, inout float3 info )
{
    float2 ip = floor(x);
    float2 fp = frac(x);
    
    float2 dmin = float2( 2.0, 2.0 );
    cell( float2(-1.0, -1.0), dmin, info, ip, fp );
    cell( float2( 0.0, -1.0), dmin, info, ip, fp );
    cell( float2( 1.0, -1.0), dmin, info, ip, fp );
    cell( float2(-1.0,  0.0), dmin, info, ip, fp );
    cell( float2( 0.0,  0.0), dmin, info, ip, fp );
    cell( float2( 1.0,  0.0), dmin, info, ip, fp );
    cell( float2(-1.0,  1.0), dmin, info, ip, fp );
    cell( float2( 0.0,  1.0), dmin, info, ip, fp );
    cell( float2( 1.0,  1.0), dmin, info, ip, fp );
    return sqrt(dmin);
}

//------------------------------------------------------

float funcS( float2 p )
{
    p *= 1.1 + 0.2*sin(1.0*TIME)*(1.0-0.75*length(p));
    p.x += TIME*0.04;
    p *= 0.7;
    p.x += 0.3*fbm4( 1.0*p.xy + float2(-TIME,0.0)*0.04 );
    p.y += 0.3*fbm4( 1.0*p.yx + float2(0.0,-TIME)*0.04 );
    float3 info = float3(0.0, 0.0, 0.0);
    float2 c = celular( 4.0*p, info );
    float f = smoothstep( 0.0,0.5, c.y - c.x );
    f -= 0.025*fbm4(48.0*info.xy);

    return f;
}

float funcC( float2 p, out float4 res )
{
    p *= 1.1 + 0.2*sin(1.0*TIME)*(1.0-0.75*length(p));
    p.x += TIME * 0.04;
    p *= 0.7;
    p.x += 0.3*fbm4( 1.0*p.xy + float2(-TIME,0.0)*0.04 );
    p.y += 0.3*fbm4( 1.0*p.yx + float2(0.0,-TIME)*0.04 );
    float3 info = float3(0.0, 0.0, 0.0);
    float2 c = celular( 4.0*p, info );
    float f = smoothstep( 0.0,0.5, c.y - c.x );
    res  = float4( c.xy, info.z, fbm4( 2.0 * float2(info.xy)) );
    return f;
}

float3 doMagic(float2 p)
{
    // patternn    
    float4 c = float4(0.0, 0.0, 0.0, 0.0);
    float f = funcC( p, c );

    // normal
    //vec2 e = vec2( 2.0/iResolution.x, 0.0 );
    float2 e = float2( 2.0/800.0, 0.0 );
    float3 nor = normalize(float3(funcS(p+e.xy) - f,
               funcS(p+e.yx) - f,
                              16.0*e.x ));

    float3 col = float3(1.0,1.0,1.0)*0.5;
    col *= f;
    col = lerp( col, float3(0.2,0.3,0.4), 1.0-c.x );
    col *= 1.0 + 1.0*float3(c.w*c.w, c.w * c.w, c.w * c.w);
    col *= 1.0 + 0.2*f;

    float dif = clamp( 0.2+0.8*dot( nor, float3(0.57703, 0.57703, 0.57703) ), 0.0, 1.0 );
    float3 lig = dif * float3(1.2,1.15,0.8) + nor.z * float3(0.1,0.2,0.5) + float3(0.5, 0.5, 0.5);
    col *= lig;
    col = 1.0-col;

    return col;
}

            fixed4 frag (pixel i) : SV_Target
			{
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////


                float2 resolution = float2(2.0, 2.0);

				float2 scaleResolution = i.uv + 1;
    			
    			float2 coordinateScale = scaleResolution.xy/resolution;
			    
                float2 coordinate = i.uv;
			    float2 coordinateResolution = i.uv/resolution;

                //Test Output 
                float3 col = float3(coordinate.x + coordinate.y, coordinate.y - coordinate.x, pow(coordinate.x,2.0f));
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                // col = 0.0;
                //////////////////////////////////////////////////////////////////////////////////////////////

                // coordinate *= 0.75;
           //      float dis = length(coordinate);
           //      if(dis < 0.5)
           //      {
			        // return float4(coordinate.xy, 0.0,1.0); 
           //      }
           //      else
           //      {
           //          return 0;
           //      }]


                // i.uv.x -= 0.5;
                // i.uv.y -= _ExampleName;
                float2 value =  (i.uv  ) * 1.0;
                value.x -= 0.5;
                value.y -= _ExampleName;
                // value.x *= 1.777;
                // value.y /= 0.5;
                col = doMagic(i.uv);
                col = float3(coordinate *2.0, 0.0);
                // col = doMagic(coordinate);



                // return float4(i.uv * 2, 0.0, 1.0);
                // return float4(col, 1.0);

                return float4(col, 1.0);

				
			}

			ENDCG
		}
	}
}

























