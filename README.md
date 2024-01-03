# Unity Shaders Compilation Study Case
Repo on Unity Shaders Study Case

![](InGameShaders.gif)

# CHECK
This repository contains the updates on shaders field game instancing, the updates on this commit, were for laser pointer, axe addition, scale addition into gameplay;

```c#

public class QuadScale : MonoBehaviour
{
   	private float RadiusMain = 0.0f;

    private float RadiusCheck = 0.0f; 
    private Transform dataWhereItIs;

    void Awake()
    {
    	Debug.Log("LOG INPUT");
        Debug.Log(transform.localScale);
        // Transform childrenTransform = GetComponentInChildren<Transform>();
        Transform childrenTransform = GetComponentInChildren(typeof(Transform)) as Transform;
 
        Debug.Log(childrenTransform.localScale);
        Debug.Log(childrenTransform.rotation);

        dataWhereItIs = this.gameObject.transform.GetChild(0);
        RadiusMain = dataWhereItIs.localScale.x;
        RadiusCheck = dataWhereItIs.localScale.x;

        Debug.Log("OUTPUT2");
        Debug.Log(dataWhereItIs.localScale);

     //    Debug.Log(dataWhereItIs.rotation);
        Debug.Log("LOG INPUT");

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
```

``` c++

            UNITY_INSTANCING_BUFFER_START(CommonProps)
                UNITY_DEFINE_INSTANCED_PROP(fixed4, _FillColor)
                UNITY_DEFINE_INSTANCED_PROP(float, _AASmoothing)
                UNITY_DEFINE_INSTANCED_PROP(float, _rangeZero_Ten)
                UNITY_DEFINE_INSTANCED_PROP(float, _rangeSOne_One)
                UNITY_DEFINE_INSTANCED_PROP(float, _rangeZoro_OneH)
                UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_x)
                UNITY_DEFINE_INSTANCED_PROP(float, _mousePosition_y)

            UNITY_INSTANCING_BUFFER_END(CommonProps)
			
			
			float _mousePosition_x = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_x);
            float _mousePosition_y = UNITY_ACCESS_INSTANCED_PROP(CommonProps, _mousePosition_y);
            float2 mouseCoordinate = mouseCoordinateFunc(_mousePosition_x, _mousePosition_y);
``