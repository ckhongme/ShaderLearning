using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ForceField : MonoBehaviour
{
    void Start()
    {

    }

    public void PointPosOnShield(Vector3 point)
    {
        Vector3 localPosition = transform.InverseTransformPoint(point);
        Vector4 toShield = new Vector4(localPosition.x, localPosition.y, localPosition.z, 1f);
        //effectTime[currentIndex] = duration;
        //collisionPoints.SetRow(currentIndex, toShield);
        //material.SetMatrix("_CollisionPoints", collisionPoints);
        //material.SetVector("_CollisionTime", effectTime);
        //currentIndex++;
        //currentIndex %= 4;
    }
}
