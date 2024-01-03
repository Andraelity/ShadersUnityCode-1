using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace MouseCommunication
{

	static public class MousePositionShader
	{
		static public float MousePositionX; 
		static public float MousePositionY; 

		static public Vector3 point;

		static public Vector3 transform_shader;

		public static string name_object = null;

		public static bool status_read = false;

		public static Vector2 GetMouseCoordinate()
		{
			traductionCoordinates();
			Vector2 outputOperation = new Vector2(MousePositionX, MousePositionY);
			return outputOperation;
		}

		public static void traductionCoordinates()
		{

			float variableOutputX = point.x - transform_shader.x;
			float variableOutputY = point.y - transform_shader.y;

			MousePositionX = variableOutputX;	
			MousePositionY = variableOutputY;	
		}

		public static void SetPoint(Vector3 input)
		{
			point = input;
		}

		public static void SetTransformShader(Vector3 inputTransformShader)
		{
			transform_shader = inputTransformShader;
		}


	}

}
