using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using MouseCommunication;

public class Laser : MonoBehaviour
{
    // Start is called before the first frame update


    private LineRenderer lr;


    [SerializeField] Transform firstPosition = null;

    void Start()
    {
    	lr = GetComponent<LineRenderer>();

    }

    // Update is called once per frame
    void Update()
    {
        lr.SetPosition(0, firstPosition.position);

        RaycastHit hit;
        string tagValue = null;

        if(Physics.Raycast(transform.position, transform.forward, out hit))
        {
        	if(hit.collider)
        	{
        		lr.SetPosition(1, hit.point);
        	}
            tagValue = hit.collider.tag;

        }
        else lr.SetPosition(1, transform.forward * 5000);


        if(Input.GetMouseButtonDown(0) && tagValue == "FramePaint")
        {
            // Debug.Log(hit.point);
            // Debug.Log(hit.collider.transform.position);
            MousePositionShader.SetPoint(hit.point);
            MousePositionShader.SetTransformShader(hit.collider.transform.position);
            Vector2 outputMouse = MousePositionShader.GetMouseCoordinate();
            // Debug.Log(outputMouse);
            GameObject sendInformation = hit.collider.gameObject;
            string sendInformation_name = hit.collider.name;
            // Debug.Log(sendInformation);
            // Debug.Log("name=  " + sendInformation_name);
            // Debug.Log("TextureCoord.");
            // Debug.Log(hit.textureCoord);
            // Debug.Log("");
            // Debug.Log("");
            // MousePositionShader.name_object = sendInformation_name;
            MousePositionShader.status_read = true;
            // Debug.Log(MousePositionShader.name_object);
            // Debug.Log(MousePositionShader.status_read);
            // Debug.Log(outputMouse);
            // Debug.Log("PROPERTIES_CLOSE");
            // Debug.Log("PROPERTIES_CLOSE");
        }

        if(Input.GetMouseButton(0) && tagValue == "FramePaint")
        {
            // Debug.Log("PROPERTIES_OPEN");
            // Debug.Log("PROPERTIES_OPEN");
            // Debug.Log("Frame Collision");
            // Debug.Log(hit.point);
            // Debug.Log(hit.collider.transform.position);
            MousePositionShader.SetPoint(hit.point);
            MousePositionShader.SetTransformShader(hit.collider.transform.position);
            Vector2 outputMouse = MousePositionShader.GetMouseCoordinate();
            // Debug.Log(outputMouse);
            GameObject sendInformation = hit.collider.gameObject;
            string sendInformation_name = hit.collider.name;
            // Debug.Log(sendInformation);
            // Debug.Log("name=  " + sendInformation_name);
            // Debug.Log("TextureCoord.");
            // Debug.Log(hit.textureCoord);
            // Debug.Log("");
            // Debug.Log("");
            MousePositionShader.name_object = sendInformation_name;
            MousePositionShader.status_read = true;
            // Debug.Log(outputMouse);
            // Debug.Log(MousePositionShader.name_object);
            // Debug.Log(MousePositionShader.status_read);


            // Debug.Log("PROPERTIES_CLOSE");
            // Debug.Log("PROPERTIES_CLOSE");
        }
           
    }
}
