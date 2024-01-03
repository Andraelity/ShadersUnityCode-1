Shader "WorldIsMine"
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


			fixed4 frag (pixel i) : SV_Target
			{
			
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

			    float3 col = 0.0;

			    float3 ro = float3(0.0, 0.0, 2.5);
			    float3 rd = normalize(float3(coordinate, -2.0));

			    col = 0.1;

			    float b = dot(ro, rd);
			    float c = dot(ro, ro) - 1.0;


			    float h = b * b - c;

			    if (h > 0.0)
			   	{
			   		float t = -b - sqrt(h);

			   		float3 pos = ro + t * rd;

			   		float3 nor = pos;

			   		float2 coordinateDistribution;
			   		coordinateDistribution.x = (mouseCoordinate.x > 0.01 || mouseCoordinate.x < -0.01)? atan2(nor.x, nor.z)/6.2831 - 0.03 * TIME - mouseCoordinate.x : atan2(nor.x, nor.z)/6.2831 - 0.03 * TIME;

			   		// coordinateDistribution.x = atan2(nor.x, nor.z)/6.2831 - 0.03 * TIME - mouseCoordinate.x;
			   		coordinateDistribution.y = acos(nor.y)/PI;
			   		coordinateDistribution.y *= 0.5;

			   		col = float3(0.2, 0.3, 0.4);
			   		float3 	te = 1.0 * tex2D(_TextureChannel0, 0.5 * coordinateDistribution.yx).xyz;
			   			   	te += 0.3 * tex2D(_TextureChannel0, 2.5 * coordinateDistribution.yx).xyz;

			   		col = lerp(col, (float3(0.2, 0.5, 0.1) * 0.55 + 0.45 * te + 0.5 * tex2D(_TextureChannel1, 15.5 * coordinateDistribution.yx).xyz) * 0.4 ,smoothstep(0.45, 0.5, te.x)); 

			   		float3 cl = tex2D(_TextureChannel1, 2.0 * coordinateDistribution).xxx;

			   		col = lerp(col, float3(0.9, 0.9, 0.9), 0.75 * smoothstep(0.55, 0.8, cl.x));

			   		float dif = max(nor.x * 2.0 + nor.z, 0.0);

			   		float fre = 1.0 - clamp(nor.z, 0.0, 1.0);
			   		float spe = clamp(dot(nor, normalize(float3(0.4, 0.3, 1.0))), 0.0, 1.0);

			   		col *= 0.03 + 0.75 * dif;
			   		col += pow(spe, 64.0) * (1.0 - te.x);
			   		col += lerp(float3(0.20, 0.10, 0.05), float3(0.4, 0.7, 1.0), dif) * 0.3 * fre;
			   		col += lerp(float3(0.02, 0.10, 0.20), float3(0.7, 0.9, 1.0), dif) * 2.5 * fre * fre * fre;

			   	}
			   	else
			   	{
			   		c = dot(ro, ro) - 10.0;
			   		h = b * b - c;
			   		float t = -b - sqrt(h);
			   		float3 pos = ro + t * rd;

			   		float3 nor = pos;

			   		float2 coordinateDistribution;

			   		coordinateDistribution.x = 16.0 * atan2(nor.x, nor.z)/6.2831 - 0.05 * TIME;
			   		coordinateDistribution.y = 2.0 * acos(nor.y)/PI;

			   		col = tex2D(_TextureChannel1, coordinateDistribution).zyx;
			   		col = col * col * col;
			   		col *= 0.15;
			   		float3 sta = tex2D(_TextureChannel1, 0.5 * coordinateDistribution).yzx;
			   		col = pow(sta, float3(8.0, 8.0, 8.0	)) * 1.3;

			   	}

			   	col = 0.5 * (col + sqrt(col));

			    return float4(col ,1.0); 

				

			}
			ENDCG
		}
	}
}

























