using System.Collections.Generic;
using UnityEngine;

namespace ShaderCode_Identity_0
{
	public class DrawMesh_Identity
	{	
		private static Mesh _quadMesh;
		private static Material _material ;
		public static float antiAliasingSmoothing = 1.5f;


		private const string FillColorParam = "_FillColor";
		private const string AASmoothingParam = "_AASmoothing";
		// private const string TextureFocus = "_TextureFocus";

		private const string stringRangeZero_Ten = "_rangeZero_Ten";
		private const string stringRangeSOne_One = "_rangeSOne_One";
		private const string stringRangeZoro_OneH = "_rangeZoro_OneH";

		private const string stringMousePosition_x = "_mousePosition_x";
		private const string stringMousePosition_y = "_mousePosition_y";

		private static MaterialPropertyBlock _materialPropertyBlock;




		public static void DrawStart(MeshInfo_Identity meshInfo)
		{
			var mesh = GetCircleMesh();
			var materialPropertyBlock = GetMaterialPropertyBlock(meshInfo);
			var matrix = GetTRSMatrix(meshInfo);
			var material = GetMaterialStart(meshInfo);
			
			Graphics.DrawMesh(mesh,matrix,material,0,null,0,materialPropertyBlock);
		}


		static Material GetMaterialStart(MeshInfo_Identity meshInfo)
		{
			
			string pathShader = meshInfo.pathShader;
			var mat = new Material(Shader.Find(pathShader));
			// var mat = new Material(Shader.Find("Hidden/Shapes/Circle"));
		
			if (SystemInfo.supportsInstancing)
			{
				mat.enableInstancing = true;
			}

			mat.SetTexture("_TextureChannel0", meshInfo.textureToChannel0);
			mat.SetTexture("_TextureChannel1", meshInfo.textureToChannel1);
			mat.SetTexture("_TextureChannel2", meshInfo.textureToChannel2);
			mat.SetTexture("_TextureChannel3", meshInfo.textureToChannel3);

			_material = mat;

			return mat;
		}


		public static void Draw(MeshInfo_Identity meshInfo)
		{
			var mesh = GetCircleMesh();
			var materialPropertyBlock = GetMaterialPropertyBlock(meshInfo);
			var matrix = GetTRSMatrix(meshInfo);
			var material = GetMaterial(meshInfo);
			
			Graphics.DrawMesh(mesh,matrix,material,0,null,0,materialPropertyBlock);
		}


		static Material GetMaterial(MeshInfo_Identity meshInfo)
		{
			
			string pathShader = meshInfo.pathShader;
			var mat = new Material(Shader.Find(pathShader));
			// var mat = new Material(Shader.Find("Hidden/Shapes/Circle"));
		
			if (SystemInfo.supportsInstancing)
			{
				mat.enableInstancing = true;
			}

			_material = mat;

			return mat;
		}
		
		static MaterialPropertyBlock GetMaterialPropertyBlock(MeshInfo_Identity meshInfo)
		{
			if (_materialPropertyBlock == null)
			{
				_materialPropertyBlock = new MaterialPropertyBlock();
			}
			
			_materialPropertyBlock.SetColor(FillColorParam, meshInfo.fillColor);
			_materialPropertyBlock.SetFloat(AASmoothingParam, antiAliasingSmoothing);
			_materialPropertyBlock.SetFloat(stringRangeZero_Ten, meshInfo.rangeZero_Ten);
			_materialPropertyBlock.SetFloat(stringRangeSOne_One, meshInfo.rangeSOne_One);
			_materialPropertyBlock.SetFloat(stringRangeZoro_OneH, meshInfo.rangeZoro_OneH);
			_materialPropertyBlock.SetFloat(stringMousePosition_x, meshInfo.mousePosition_x);
			_materialPropertyBlock.SetFloat(stringMousePosition_y, meshInfo.mousePosition_y);


			return _materialPropertyBlock;
		}



		static Matrix4x4 GetTRSMatrix(MeshInfo_Identity meshInfo)
		{
			var rotation = Quaternion.LookRotation(meshInfo.forward);


			return Matrix4x4.TRS(meshInfo.center, rotation, new Vector3(meshInfo.radius, meshInfo.radius, 1f));
			
		}

		
		static Mesh GetCircleMesh()
		{
			if (_quadMesh != null)
			{
				return _quadMesh;
			}

			_quadMesh = CreateQuadMesh();

			return _quadMesh;
		}
	
		private static Mesh CreateQuadMesh()
		{
			var quadMesh = new Mesh();
			quadMesh.SetVertices(new List<Vector3>
			{
				new Vector3(-1f, -1f, 0f),
				new Vector3(1f, -1f, 0f),
				new Vector3(1f, 1f, 0f),
				new Vector3(-1f, 1f, 0f)
			});

			quadMesh.triangles = new[]
			{
				0, 2, 1,
				0, 3, 2
			};

			var uvMin = -1f;
			var uvMax = 1f;
		
			quadMesh.uv = new[]
			{
				new Vector2(uvMin, uvMin),
				new Vector2(uvMax, uvMin),
				new Vector2(uvMax, uvMax),
				new Vector2(uvMin, uvMax)
			};

			return quadMesh;
		}
	}
}
