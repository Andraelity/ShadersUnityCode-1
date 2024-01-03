using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuadScale : MonoBehaviour
{
   	private float RadiusMain = 0.0f;

    private float RadiusCheck = 0.0f; 
    private Transform dataWhereItIs;

    void Awake()
    {
    	// Debug.Log("LOG INPUT");
        // Debug.Log(transform.localScale);
        // Transform childrenTransform = GetComponentInChildren<Transform>();
        Transform childrenTransform = GetComponentInChildren(typeof(Transform)) as Transform;
 
        Debug.Log(childrenTransform.localScale);
        Debug.Log(childrenTransform.rotation);

        dataWhereItIs = this.gameObject.transform.GetChild(0);
        RadiusMain = dataWhereItIs.localScale.x;
        RadiusCheck = dataWhereItIs.localScale.x;

        // Debug.Log("OUTPUT2");
        // Debug.Log(dataWhereItIs.localScale);

     //    Debug.Log(dataWhereItIs.rotation);
        // Debug.Log("LOG INPUT");

    }

    // Update is called once per frame
    void Update()
    {

        dataWhereItIs = this.gameObject.transform.GetChild(0);
        RadiusCheck = dataWhereItIs.localScale.x;
		if(RadiusCheck != RadiusMain)
		{
            RadiusMain = RadiusCheck;
			UpdateScale(RadiusMain);

	
    	}

    }

    void UpdateScale(float input)
    {
    	float ratioChange = 0.25f * input;

		Vector3 valueToUpdate = new Vector3(ratioChange, ratioChange, ratioChange);	
		transform.localScale = valueToUpdate;
    }
}
