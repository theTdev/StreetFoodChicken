using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTurningScript : MonoBehaviour
{
    private float lerpDuration = 1F;
    private bool rotating = false;
    private bool camTurned = false;

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space) && !rotating)
        {
            StartCoroutine(Rotate180());
        }
    }

    IEnumerator Rotate180()
    {
        rotating = true;
        float timeElapsed = 0F;
        Quaternion startRotation = transform.rotation;
        Quaternion endRotation = transform.rotation * Quaternion.Euler(0,camTurned ? 0 : 180, 0);
        while (timeElapsed < lerpDuration)
        {
            transform.rotation = Quaternion.Slerp(startRotation, endRotation, timeElapsed / lerpDuration);
            timeElapsed += Time.deltaTime;
            yield return null;
        }
        
        camTurned = !camTurned;
        transform.rotation = endRotation;
        rotating = false;
    }
}
