Shader "FloatingSpheres"
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
      			
                #define PI 3.1415927
                #define TIME _Time.y
      
                float2 mouseCoordinateFunc(float x, float y)
                {
                	return normalize(float2(x,y));
                }
            /////////////////////////////////////////////////////////////////////////////////////////////
            // Default 
            /////////////////////////////////////////////////////////////////////////////////////////////


float4 fpar00[6];
float4 fpar01[6];

float cylinder( in float4 sph, in float3 ro, in float3 rd )
{
    float3  d = ro - sph.xyz;
    float a = dot( rd.xz, rd.xz );
    float b = dot( rd.xz, d.xz );
    float c = dot( d.xz, d.xz ) - sph.w*sph.w;
    float t;

    t = b*b - a*c;
    if( t>0.0 )
    {
        t = -(b+sqrt( t ))/a;
    }

    return t-.001;

}


float esfera( in float4 sph, in float3 ro, in float3 rd )
{
    float3  d = ro - sph.xyz;
    float b = dot( rd, d );
    float c = dot(  d, d ) - sph.w*sph.w;
    float t = b*b - c;

    if( t>0.0 )
    {
        t = -b - sqrt( t );
    }

    return t-.001;
}


bool esfera2( in float4 sph, in float3 ro, in float3 rd, in float tmin )
{
    float3  d = ro - sph.xyz;
    float b = dot( rd, d );
    float c = dot(  d, d ) - sph.w*sph.w;

    float t = b*b - c;
    bool r = false;

    if( t>0.0 )
    {
        t = -b - sqrt( t );
        r = (t>0.0) && (t<tmin);
    }

    return r;
}

bool cylinder2( in float4 sph, in float3 ro, in float3 rd, in float tmin )
{
    float3 d = ro - sph.xyz;
    float a = dot( rd.xz, rd.xz );
    float b = dot( rd.xz, d.xz );
    float c = dot( d.xz, d.xz ) - sph.w*sph.w;
    float t = b*b - a*c;
    bool r = false;
    if( t>0.0 )
    {
        t = -(b+sqrt(t));
        r = (t>0.0) && (t<(tmin*a));
    }
    return r;
}

float plane( in float4 pla, in float3 ro, in float3 rd )
{
    float de = dot(pla.xyz, rd);
    de = sign(de)*max( abs(de), 0.001);
    float t = -(dot(pla.xyz, ro) + pla.w)/de;
    return t;
}

float3 calcnor( in float4 obj, in float4 col, in float3 inter, out float2 uv )
{
    float3 nor;
    if( col.w>2.5 )
    {
        nor.xz = inter.xz - obj.xz;
        nor.y = 0.0;
        nor = nor/obj.w;
        //uv = vec2( atan(nor.x,nor.z)/3.14159, inter.y );
        uv = float2( nor.x, inter.y );
    }
    else if( col.w>1.5 )
    {
        nor = obj.xyz;
        uv = inter.xz*.2;
    }
    else
    {
        nor = inter - obj.xyz;
        nor = nor/obj.w;
        uv = nor.xy;
    }

    return nor;
}

float4 cmov( in float4 a, in float4 b, in bool cond )
{
    return cond?b:a;
}

float cmov( in float a, in float b, in bool cond )
{
    return cond?b:a;
}

int cmov( in int a, in int b, in bool cond )
{
    return cond?b:a;
}

float intersect( in float3 ro, in float3 rd, out float4 obj, out float4 col )
{
    float tmin = 100000.0;
    float t;

    obj = fpar00[5];
    col = fpar01[5];

    bool isok;

    t = esfera( fpar00[0], ro, rd );
    isok = (t>0.001) && (t<tmin);
    obj  = cmov( obj, fpar00[0], isok );
    col  = cmov( col, fpar01[0], isok );
    tmin = cmov( tmin, t, isok );

    t = esfera( fpar00[1], ro, rd );
    isok = (t>0.001) && (t<tmin);
    obj  = cmov( obj, fpar00[1], isok );
    col  = cmov( col, fpar01[1], isok );
    tmin = cmov( tmin, t, isok );

    t = cylinder( fpar00[2], ro, rd );
    isok = ( t>0.001 && t<tmin );
    obj  = cmov( obj, fpar00[2], isok );
    col  = cmov( col, fpar01[2], isok );
    tmin = cmov( tmin, t, isok );

    t = cylinder( fpar00[3], ro, rd );
    isok = ( t>0.0 && t<tmin );
    obj  = cmov( obj, fpar00[3], isok );
    col  = cmov( col, fpar01[3], isok );
    tmin = cmov( tmin, t, isok );

    t = plane( fpar00[4], ro, rd );
    isok = ( t>0.001 && t<tmin );
    obj  = cmov( obj, fpar00[4], isok );
    col  = cmov( col, fpar01[4], isok );
    tmin = cmov( tmin, t, isok );

    t = plane( fpar00[5], ro, rd );
    isok = ( t>0.001 && t<tmin );
    obj  = cmov( obj, fpar00[5], isok );
    col  = cmov( col, fpar01[5], isok );
    tmin = cmov( tmin, t, isok );

    return tmin;
}

bool intersectShadow( in float3 ro, in float3 rd, in float l )
{
    float t;

    float4 sss;

    sss.x = esfera2(   fpar00[0], ro, rd, l );
    sss.y = esfera2(   fpar00[1], ro, rd, l );
    sss.z = cylinder2( fpar00[2], ro, rd, l );
    sss.w = cylinder2( fpar00[3], ro, rd, l );

    return any(sss);
}

float4 basicShade( in float3 inter, in float4 obj, 
                 in float4 col, in float3 rd, 
                 in float4 luz, 
                 out float4 ref )
{
    float2 uv;

    float3 nor = calcnor( obj, col, inter, uv );

    ref.xyz = reflect( rd, nor );
    float spe = dot( ref.xyz, luz.xyz );
    spe = max( spe, 0.0 );
    spe = spe*spe;
    spe = spe*spe;

    float dif = clamp( dot( nor, luz.xyz ), 0.0, 1.0 );
	bool sh = intersectShadow( inter, luz.xyz, luz.w );
    if( sh )
    {
        dif = 0.0;
		spe = 0.0;
    }

    col *= tex2D( _TextureChannel0, uv );

    // amb + dif + spec

    float dif2 = clamp( dot( nor, luz.xyz*normalize(float3(-1.0,0.1,-1.0)) ), 0.0, 1.0 );

	col = col*( 0.2 * float4(0.4,0.50,0.6,1.0) * (0.8 + 0.2 * nor.y) + 
                0.6 * float4(1.0,1.00,1.0,1.0) * dif2 +  
                1.3 * float4(1.0,0.95,0.8,1.0) * dif ) + 0.5 * spe;

    // fresnel
    dif = clamp( dot( nor, -rd ), 0.0, 1.0 );
    ref.w = dif;
    dif = 1.0 - dif*dif;
	dif = pow( dif, 4.0 );
    col += 1.0*float4( dif, dif, dif, dif )*col*(sh?0.5:1.0);

    return col;
}

float3 render( in float2 fragCoord, float2 mouseInput )
{
    float4  luz;
    float4  obj;
	float4  col;
    float3  nor;
    float4  ref;
	
    float2 p = fragCoord;
    float2 q = (fragCoord + 1 ) /float2(2,2);
    float2 mouse = mouseInput;
    fpar00[0] = float4( 1.2*sin( 6.2831*.33* TIME + 0.0 ), 0.0,  
                      1.8*sin( 6.2831*.39* TIME + 1.0 ), 1 );
    fpar00[1] = float4( 1.5*sin( 6.2831*.31* TIME + 4.0 ), 
                      1.0*sin( 6.2831*.29* TIME + 1.9),  
                      1.8*sin( 6.2831*.29* TIME + 0.0 ), 1 );
    fpar00[2] = float4( -1.2,  0.0, -0.0, 0.4 );
    fpar00[3] = float4(  1.2,  0.0, -0.0, 0.4 );
    fpar00[4] = float4(  0.0,  1.0,  0.0, 2.0 );
    fpar00[5] = float4(  0.0, -1.0,  0.0, 2.0 );


    fpar01[0] = float4( 0.9, 0.8, 0.6, 1.0 );
    fpar01[1] = float4( 1.0, 0.6, 0.4, 1.0 );
    fpar01[2] = float4( 0.8, 0.6, 0.5, 3.0 );
    fpar01[3] = float4( 0.5, 0.5, 0.7, 3.0 );
    fpar01[4] = float4( 1.0, 0.9, 0.9, 2.0 );
    fpar01[5] = float4( 1.0, 0.9, 0.9, 2.0 );

    float an = .15*TIME - 6.2831* mouse.x;
    float di = mouse.y;
    float2 sc = float2(cos(an),sin(an));
    float3 rd = normalize(float3(p.x*sc.x-sc.y,p.y,sc.x+p.x*sc.y));
    float3 ro = (3.5-di*2.5)*float3(sc.y,0.0,-sc.x);

    float tmin = intersect( ro, rd, obj, col );

    float3 inter = ro + rd*tmin;

    luz.xyz = float3(0.0,1.5,-3.0)-inter;
    luz.w = length( luz.xyz );
    luz.xyz = luz.xyz/luz.w;

    col = basicShade( inter, obj, col, rd, luz, ref );

// // #if 0
//     float4 col2;
//     float4 ref2;
//     tmin = intersect( inter, ref.xyz, obj, col2 );
//     inter = inter + ref.xyz*tmin;
//     luz.xyz = float3(0.0,1.5,-1.0)-inter;
//     luz.w = length( luz.xyz );
//     luz.xyz = luz.xyz/luz.w;
//     col2 = basicShade( inter, obj, col2, ref.xyz, luz, ref2 );

//     col = lerp( col, col2, .5-.5*ref.w );
// // #endif
    
    col = sqrt( col );
	
	col *= 0.6 + 0.4*pow( 16.0*q.x*q.y*(1.0-q.x)*(1.0-q.y), 0.25 );
 
    return col.xyz;
}


            #define AA 2
		
            fixed4 frag (pixel i) : SV_Target
			{
				
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
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
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                col = 0.0;
                //////////////////////////////////////////////////////////////////////////////////////////////

                float2 fragCoord = coordinate;

                float3 col0 = render( (fragCoord.xy+float2(0.0,0.0) ),mouseCoordinate);
                float3 col1 = render( (fragCoord.xy+float2(0.5,0.0) ),mouseCoordinate);
                float3 col2 = render( (fragCoord.xy+float2(0.0,0.5) ),mouseCoordinate);
                float3 col3 = render( (fragCoord.xy+float2(0.5,0.5) ),mouseCoordinate);
                col = 0.25*(col0 + col1 + col2 + col3);
                float2 q = coordinateScale;
                // fragColor = float4(q,0.0,1.0);


                
			    return float4(col,1.0); 

				
			}

			ENDCG
		}
	}
}

























