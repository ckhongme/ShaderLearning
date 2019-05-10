using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderTest : MonoBehaviour
{
    public Material targetMat;
	
	void Update ()
    {
        if(targetMat == null)
            return;

        if (Input.GetKeyDown(KeyCode.Space))
            _SandEffect(transform);
    }

    private void _Explore(Transform target)
    {
        MeshRenderer[] renderers = target.GetComponentsInChildren<MeshRenderer>();
        targetMat.SetFloat("_StartTime", Time.timeSinceLevelLoad);

        for (int i = 0; i < renderers.Length; i++)
        {
            renderers[i].material = targetMat;
        }
    }

    private void _SandEffect(Transform target)
    {
        MeshRenderer[] renderers = target.GetComponentsInChildren<MeshRenderer>();
        targetMat.SetFloat("_StartTime", Time.timeSinceLevelLoad);
        targetMat.SetFloat("_FloorY", -1);

        for (int i = 0; i < renderers.Length; i++)
        {
            renderers[i].material = targetMat;
        }
    }
}
