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
    private float speed = 5F;
    private bool allowMove { get; set; } = false;

    private void FixedUpdate()
    {
        if (Input.GetKeyDown(KeyCode.P))
        {
        }
        
        //Calculate the input
        float hInput = 0;

        if (allowMove)
        {
            if (Input.GetKey(KeyCode.D))
            {
                hInput = 1;
            }
            else hInput = -1;
        }

        //Animate the chicken
        Animator animator = chickenSelf.GetComponent<Animator>();
        animator.SetFloat("InputX", hInput);
        
        //Move the chicken
        if (allowMove)
        {
            Vector3 movement = new Vector3(hInput, 0, 0);
            GetComponent<CharacterController>().SimpleMove(movement * speed);
        }
    }
}
