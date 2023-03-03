using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class UIManagement : MonoBehaviour
{
    public GameObject titleText;
    public GameObject startButton;
    public GameObject walkButton;
    public GameObject chicken;
    public GameObject invincibleButton;

    private void Start()
    {
        titleText.SetActive(true);
        startButton.SetActive(true);
        walkButton.SetActive(false);
        PlayerMovement playerMovement = chicken.GetComponent<PlayerMovement>();
        playerMovement.allowMove = false;
        invincibleButton.SetActive(false);
    }
    
    public void StartGame()
    {
        invincibleButton.SetActive(false);
        titleText.SetActive(false);
        startButton.SetActive(false);
        walkButton.SetActive(true);
        PlayerMovement playerMovement = chicken.GetComponent<PlayerMovement>();
        playerMovement.allowMove = true;
    }
}
