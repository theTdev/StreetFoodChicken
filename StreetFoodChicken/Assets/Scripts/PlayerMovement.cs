using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
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

    public GameObject uiManager;
    public bool allowMove = false;
    public bool allowMoveBackwards = true;
    public float speed = 1.5F;
    public GameObject chickenToon;
    private int collectedChickensAmount = 0;
    public Material shaderMat;
    public bool invincible = false;
    public GameObject chickenScoreText;
    public GameObject walkScoreText;
    private void FixedUpdate()
    {
        double score = System.Math.Round(transform.position.x, 2);
        walkScoreText.GetComponent<TextMeshProUGUI>().SetText((score <= 0 ? 0 : score) + " m");
        chickenScoreText.GetComponent<TextMeshProUGUI>().SetText("" + collectedChickensAmount);
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
        StartCoroutine(GoInvincible(15, true, true));
    }

    public void RestartGoInvincible()
    {
        allowMove = true;
        WithdrawChickens(4);
        StartCoroutine(GoInvincible(5, false, false));
    }

    IEnumerator GoInvincible(int time, bool playDifMusic, bool difSpeed)
    {
        if (playDifMusic)
        {
            chickenSelf.GetComponent<AudioSource>().Play();
            GetComponent<AudioSource>().Pause();
        }
        allowMoveBackwards = false;
        invincible = true;
        speed = difSpeed ? 10.5F : 1.5F;
        Material material = chickenToon.GetComponent<SkinnedMeshRenderer>().material;
        chickenToon.GetComponent<SkinnedMeshRenderer>().material = shaderMat;
        yield return new WaitForSeconds(time);
        if (playDifMusic)
        {
            GetComponent<AudioSource>().Play();
            chickenSelf.GetComponent<AudioSource>().Stop();
        }
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

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Car") && !invincible)
        {
            float score = (float) System.Math.Round(this.transform.position.x, 2);

            if (PlayerPrefs.HasKey("Highscore"))
            {
                if (score > PlayerPrefs.GetFloat("Highscore", 0))
                {
                    PlayerPrefs.SetFloat("Highscore", score);
                }
            } else PlayerPrefs.SetFloat("Highscore", score);
            
            PlayerPrefs.Save();

        this.allowMove = false;
            uiManager.GetComponent<UIManagement>().EnableDeathScreen(this.collectedChickensAmount >= 4);
        }
    }
}
