Shader "Sierpinski"
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


            float4 setColor(float2 coord, bool isHole)
            {

            	float4 color;
            	if(isHole)
            	{
            		color = 0.001;
            	}
            	else
            	{
            		color = float4(coord.x, 0.5, coord.y, 1.0);
            	}

            	return color;
            }

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

                float2 coordinateBase = i.uv;

                float2 coordinate = i.uv/float2(2,2);

				float2 scaleResolution = i.uv + 1;

    			float2 coordinateScale = scaleResolution.xy/float2(2, 2);


                //Test Output 
                float3 col = float3(coordinate.x + coordinate.y, coordinate.y - coordinate.x, pow(coordinate.x,2.0f));
                float3 col2 = float3(coordinateBase.x + coordinateBase.y, coordinateBase.y - coordinateBase.x, pow(coordinateBase.x,2.0f));
				//////////////////////////////////////////////////////////////////////////////////////////////
				///	DEFAULT
				//////////////////////////////////////////////////////////////////////////////////////////////
	
                col = 0.0;
                //////////////////////////////////////////////////////////////////////////////////////////////


                const int lim = 5;

                bool doInverseHoles = (fmod(TIME, 6.0) < 3.0);


                float2 center = float2(0.5, 0.5);
                float2x2 rotation = {cos(TIME), sin(TIME), -sin(TIME), cos(TIME)};



                float2 coordRot = mul(rotation,(coordinateScale - center)) + center;


                if(coordRot.x < 0.0 || coordRot.x > 1.0 || coordRot.y < 0.0 || coordRot.y > 1.0)
                {
                	col = setColor(coordinateScale, true);
                	return float4(col,1.0);
                }

                float2 sectors;
                float2 coordIter = coordRot;
                bool isHole = false;

                for(int i = 0; i < lim; i++)
                {
                	sectors = float2(floor(coordIter.xy * 3.0));
                	if(sectors.x == 1 && sectors.y == 1)
                	{
                		if(doInverseHoles)
                		{
                			isHole = !isHole;
                		}
                		else
                		{
                			col = setColor(coordinateScale, true);
                			return float4(col,1.0);
                		}
                	}
                	if( i + 1 < lim)
                	{
                		coordIter.xy = coordIter.xy * 3.0 - float2(sectors.xy);
                	}

                }

              //   if(col.x < 0.01 && col.y < 0.01 && col.z < 0.1)
              //   {

            		// return float4(col2, 1.0);
                
              //   }
              //   else
              //   {
              //   	return 0;
              //   }
				col = setColor(isHole ? coordinateScale : coordRot, isHole);

                if(col.x < 0.01 && col.y < 0.01 && col.z < 0.1)
                {
 
            		return float4(col2, 1.0);
                
                }
                
				return float4(col, 1.0);	
			}

			ENDCG
		}
	}
}

























