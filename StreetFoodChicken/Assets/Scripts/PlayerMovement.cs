using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
    [Header("Camera")]
    [Tooltip("The Parent Object of the Camera")]
    public GameObject cameraObj;
    [Header("Movement")]
    [Tooltip("The Chicken with the Animator Component")]
    public GameObject chickenSelf;

    [Tooltip("The Object to recognize what Input to use")]
    public GameObject inputObj;
    public bool allowMove = false;
    private float speed = 1.5F;

    private void FixedUpdate()
    {
        float hInput = 0;

        if (allowMove)
        {
            if (!inputObj.activeSelf)
            {
                hInput = 1;
            }
            else hInput = -1;
        }

        Animator animator = chickenSelf.GetComponent<Animator>();
        animator.SetFloat("InputX", hInput);
        
        if (allowMove)
        {
            Vector3 movement = new Vector3(hInput, 0, 0);
            GetComponent<CharacterController>().SimpleMove(movement * speed);
        }
    }

    public void TurnCamera()
    {
        cameraObj.GetComponent<CameraTurningScript>().TurnCamera();
    }
}
