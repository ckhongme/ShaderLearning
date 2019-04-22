using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Scan : MonoBehaviour
{
    private Material m;

    [Range(0, 10)]
    public float lineWidth = 2f;

    [Range(0, 1)]
    public float hardness = 0.9f;

    [Range(0, 1)]
    public float displacementSpeed = 0.1f;

    void Start ()
    {
        m = GetComponent<Renderer>().material;
        m.SetFloat("_LineWidth", lineWidth);
        m.SetFloat("_Hardness", hardness);
        m.SetFloat("_Speed", displacementSpeed);
    }
}
