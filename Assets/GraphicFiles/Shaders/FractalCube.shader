Shader "FractalCube"
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

            float maxcomp(in float3 coordinateInput)
            {
            	return max(coordinateInput.x, max(coordinateInput.y, coordinateInput.z));
            }

            float sdBox( float3 p, float3 b)
            {

            	float3 di = abs(p) - b;
            	float mc = maxcomp(di);
            	return min(mc,length(max(di,0.0)));
            }

            float2 iBox(in float3 ro, in float3 rd, in float3 rad)
            {
            	float3 m = 1.0/rd;
            	float3 n = m * ro;
            	float3 k = abs(m) * rad;
            	float3 t1 = -n - k; 
            	float3 t2 = -n + k; 
            	return float2(max( max(t1.x, t1.y), t1.z), 
            				  min( min(t2.x, t2.y), t2.z));

            }
            
            const float3x3 ma = { 0.60, 0.00 ,0.80, 0.00, 1.00, 0.00, -0.80, 0.00, 0.60};

            float4 map( in float3 p) 
            {

            	float d = sdBox(p, float3(1.0, 1.0, 1.0));
            	float4 res = float4(d, 1.0, 0.0, 0.0);

            	float ani = smoothstep(-0.2, 0.2, -cos(0.5 *TIME));

            	float off = 1.5 * sin (0.01 * TIME);

            	float s = 1.0;

            	for(int m = 0; m<4; m++)
            	{
            		p = lerp(p, mul(ma, (p + off)), ani);

            		float3 a = fmod(p*s, 2.0) - 1.0;
            		s *= 3.0;
            		float3 r = abs(1.0 - 3.0 * abs(a));
            		float da = max(r.x, r.y);
            		float db = max(r.y, r.z);
            		float dc = max(r.z, r.x);
            		float c =  (min(da, min(db, dc)) - 1.0)/s;

            		if( c > d)
            		{
            			d = c; 
            			res = float4(d, min(res.y, 0.2*da*db*dc), (1.0 + float(m))/4.0, 0.0);
            		}
            	}

            	return res;

            }


            float4 intersect( in float3 ro, in float3 rd)
            {
            	float2 bb = iBox(ro, rd, float3(1.05, 1.05, 1.05));
            	if( bb.y < bb.x ) return float4(-1.0, -1.0, -1.0, -1.0);

            	float tmin = bb.x;
            	float tmax = bb.y;

            	float t = tmin;
            	float4 res = float4(-1.0, -1.0, -1.0, -1.0);
            	for(int i =0 ; i < 64; i++)
            	{
            		float4 h = map (ro + rd * t);
            		if(h.x < 0.002 || t > tmax) break;
            		res = float4(t, h.yzw);
            		t  += h.x;
            	}
            	if(t > tmax)
            	{
            	 	res = float4(-1.0, -1.0, -1.0, -1.0);
            	}

            	return res;
			}

            float softshadow( in float3 ro, in float3 rd, float mint, float k)
            {
            	float2 bb = iBox(ro, rd, float3(1.05, 1.05, 1.05));
            	float tmax = bb.y;

            	float res = 1.0;
            	float t = mint;

            	for(int i = 0; i < 64; i++)
            	{
            		float h = map(ro + rd * t).x;
            		res = min(res, k*h/t);
            		if(res < 0.001) break;
            		t += clamp(h, 0.005, 0.1);
            		if (t>tmax) break;
            	}
            	return clamp(res, 0.0, 1.0);
            }

            float3 calcNomral(in float3 pos)
            {
            	float3 eps = float3(0.001, 0.0, 0.0);
            	float3 element = normalize(float3(map(pos+eps.xyy).x - map(pos-eps.xyy).x, map(pos+eps.yxy).x - map(pos-eps.yxy).x, map(pos+eps.yyx).x - map(pos-eps.yyx).x));
            	return element;
            }


            float3 render( in float3 ro, in float3 rd)
            {

            	float3 col = lerp(float3(0.3, 0.2, 0.1) * 0.5, float3(0.7, 0.9, 1.0), 0.5 + 0.5 * rd.y);

            	float4 tmat = intersect(ro, rd);

            	if(tmat.x > 0.0)
            	{

            		float3 pos = ro + tmat.x * rd;
            		float3 nor = calcNomral(pos);
            		float3 matcol = 0.5 + 0.5 * cos(float3(0.0, 1.0, 2.0) + 2.0 * tmat.z); 

            		float occ = tmat.y;	

            		const float3 light = normalize(float3(1.0,0.9,0.3));

            		float dif = dot(nor, light);

            		float sha = 1.0;
            		if(dif > 0.0) sha = softshadow(pos, light, 0.01, 64.0);

            		dif = max (dif,0.0);

            		float3 hal = normalize(light - rd);
            		float spe = dif * sha * pow(clamp(dot(hal,nor), 0.0, 1.0), 16.0) * (0.04 + 0.96 * pow(clamp(1.0 - dot(hal, light), 0.0, 1.0), 5.0));

            		float sky = 0.5 + 0.5 * nor.y;

            		float bac = max(0.4 + 0.6 * dot(nor, float3(-light.x, light.y, -light.z)), 0.0);

            		float3 lin = float3(0.0, 0.0, 0.0);

            		lin += 1.00 * dif * float3(1.10, 0.85, 0.60) * sha;

            		lin += 0.50 * sky * float3(0.10, 0.20, 0.40) * occ;

            		lin += 0.10 * bac * float3(1.00, 1.00, 1.00) * (0.5 + 0.5 * occ);

            		lin += 0.25 * occ * float3(0.15, 0.17, 0.20);
            		col = matcol * lin + spe * 128.0;

            	}

            	col = 1.5 * col/(1.0 + col);
            	col = sqrt(col);

            	return col;
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

			    float3 ro = 1.1 * float3(2.5 * sin(0.25 * TIME), 1.0 + 1.0 * cos(TIME * 0.13), 2.5 * cos(0.25*TIME));

			    // for(int m = 0; m < AA; m++)
			    // {
			    	// for (int n = 0; n < AA; n++)
			    	// {
			    		float3 ww = normalize(float3(0.0,0.0,0.0) - ro);
			    		float3 uu = normalize(cross(float3(0.0, 1.0, 0.0), ww ));
			    		float3 vv = normalize(cross(ww, uu));
			    		float3 rd = normalize(coordinate.x * uu + coordinate.y * vv + 2.5 * ww);

			    		col += render(ro, rd);
			    	// }
			    // }
			    // col /= float(AA*AA);


			    return float4(col,1.0); 

				
			}

			ENDCG
		}
	}
}

























