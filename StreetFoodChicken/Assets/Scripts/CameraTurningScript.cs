using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTurningScript : MonoBehaviour
{
    public GameObject chicken;
    public GameObject chickenSelf;
    private float lerpDuration = 1F;
    private bool rotating = false;

    public void TurnCamera()
    {
        if (!rotating)
        {
            StartCoroutine(Rotate180());
        }
    }

    IEnumerator Rotate180()
    {
        chicken.GetComponent<PlayerMovement>().allowMove = false;
        rotating = true;
        float timeElapsed = 0F;
        Quaternion startRotation = transform.rotation;
        Quaternion endRotation = transform.rotation * Quaternion.Euler(0,180, 0);
        float f = 0;

        while (timeElapsed < lerpDuration)
        {
            transform.rotation = Quaternion.Slerp(startRotation, endRotation, timeElapsed / lerpDuration);
            timeElapsed += Time.deltaTime;
            chickenSelf.GetComponent<Animator>().SetFloat("InputY", f);
            f += 0.1F;
            yield return null;
        }

        while (f > 0)
        {
            chickenSelf.GetComponent<Animator>().SetFloat("InputY", f);
            f -= 0.1F;
            yield return null;
        }
        transform.rotation = endRotation;
        rotating = false;
        yield return new WaitForSeconds(1);
        chicken.GetComponent<PlayerMovement>().allowMove = true;
    }
}
