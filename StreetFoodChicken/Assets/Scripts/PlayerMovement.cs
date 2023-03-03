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
    public GameObject goInvincibleButton;

    [Tooltip("The Object to recognize what Input to use")]
    public GameObject inputObj;
    public bool allowMove = false;
    public bool allowMoveBackwards = true;
    public float speed = 1.5F;
    public GameObject chickenToon;
    private int collectedChickensAmount = 0;
    public Material shaderMat;
    public bool invincible = false;

    private void FixedUpdate()
    {
        float hInput = 0;

        if (Input.GetKeyDown(KeyCode.Space))
        {
            CollectChicken();
        }
        if (allowMove)
        {
            if (!inputObj.activeSelf)
            {
                hInput = 1;
            }
            else if (allowMoveBackwards) hInput = -1;
        }

        Animator animator = chickenSelf.GetComponent<Animator>();
        animator.SetFloat("InputX", invincible && hInput >= 0.5 ? 5 : hInput);
        
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

    public void CollectChicken()
    {
        if (!invincible)
        {
            this.collectedChickensAmount += 1;
        }

        if (collectedChickensAmount >= 2)
        {
            goInvincibleButton.SetActive(true);
        }
    }

    public void StartGoInvincible()
    {
        WithdrawChickens(2);
        StartCoroutine(GoInvincible());
    }

    IEnumerator GoInvincible()
    {
        allowMoveBackwards = false;
        invincible = true;
        speed = 10.5F;
        Material material = chickenToon.GetComponent<SkinnedMeshRenderer>().material;
        chickenToon.GetComponent<SkinnedMeshRenderer>().material = shaderMat;
        yield return new WaitForSeconds(10);
        speed = 1.5F;
        chickenToon.GetComponent<SkinnedMeshRenderer>().material = material;
        invincible = false;
        allowMoveBackwards = true;
    }

    public void WithdrawChickens(int amount)
    {
        if (this.collectedChickensAmount <= 2) collectedChickensAmount = 0;
        else this.collectedChickensAmount -= amount;

        if (collectedChickensAmount < 2)
        {
            goInvincibleButton.SetActive(false);
        }
    }
}
