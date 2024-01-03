using UnityEngine;
using UnityEngine.Rendering;

using System;
using System.IO;
using System.Collections.Generic;

using ShaderCode_Identity_0;

using MouseCommunication; 

namespace AttachScript_0
{
	
	public class FocusRenderer_Identity : MonoBehaviour {
		


		public Color FillColor;
		public string Path;
		public string TextureChannel0;
		public string TextureChannel1;
		public string TextureChannel2;
		public string TextureChannel3;
		
		[Range(1f, 1000f)] public float Radius = 2f;
		[Range(0f, 10f)] public float RangeZero_Ten = 2f;
		[Range(-1f, 1f)] public float RangeSOne_One = 1f;
		[Range(0f, 100f)] public float RangeZoro_OneH = 2f;


		private Texture2D TextureToShaderChannel0;
		private Texture2D TextureToShaderChannel1;
		private Texture2D TextureToShaderChannel2;
		private Texture2D TextureToShaderChannel3;
		
		
		private float mousePosition_x = 0.0f;
		private float mousePosition_y = 0.0f;


		MeshInfo_Identity meshToPaint;

		[SerializeField] public string nameObject = null; 

		void Start()
		{
			
			TextureToShaderChannel0 = (Texture2D)Resources.Load(TextureChannel0);
			TextureToShaderChannel1 = (Texture2D)Resources.Load(TextureChannel1);
			TextureToShaderChannel2 = (Texture2D)Resources.Load(TextureChannel2);
			TextureToShaderChannel3 = (Texture2D)Resources.Load(TextureChannel3);

			meshToPaint = new MeshInfo_Identity
			{
				center = transform.position,
				forward = transform.forward,
				radius = Radius,
				fillColor = FillColor,
				pathShader = Path,
				textureToChannel0 = TextureToShaderChannel0,
				textureToChannel1 = TextureToShaderChannel1,
				textureToChannel2 = TextureToShaderChannel2,
				textureToChannel3 = TextureToShaderChannel3,
				rangeZero_Ten = RangeZero_Ten,
				rangeSOne_One = RangeSOne_One,
				rangeZoro_OneH = RangeZoro_OneH

			};

			
			DrawMesh_Identity.DrawStart(meshToPaint);
			mousePosition_x = 0.0f;
			nameObject = name;

			// print("VALUES SCALE START");
			// Debug.Log(transform.localScale);

			// transform.localScale = new Vector3(10.0f,0.0f,0.0f);
			// Debug.Log(transform.localScale);

			// print("VALUES SCALE START");


		}

		private void Update()
		{

			if(MousePositionShader.status_read == true)
			{
				if(MousePositionShader.name_object == nameObject)
				{
					MousePositionShader.status_read = false;
					mousePosition_x = -MousePositionShader.MousePositionX;
					mousePosition_y = MousePositionShader.MousePositionY;

					// Debug.Log("Mouse Position FocusRenderer_Identity");
					// Debug.Log(mousePosition_x + "  " + mousePosition_y);
					// Debug.Log("Mouse Position FocusRenderer_Identity");

				}
			}

			meshToPaint.radius = Radius;
			meshToPaint.rangeZero_Ten = RangeZero_Ten;
			meshToPaint.rangeSOne_One = RangeSOne_One;
			meshToPaint.rangeZoro_OneH = RangeZoro_OneH;
			meshToPaint.mousePosition_y = mousePosition_y;
			meshToPaint.mousePosition_x = mousePosition_x;
			DrawMesh_Identity.DrawStart(meshToPaint);
			transform.localScale = new Vector3(Radius, 0.0f, 0.0f);

		}


		void Awake()
		{
		}

	}
}
