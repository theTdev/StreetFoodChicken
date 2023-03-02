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

    private void Start()
    {
        titleText.SetActive(true);
        startButton.SetActive(true);
        walkButton.SetActive(false);
        PlayerMovement playerMovement = chicken.GetComponent<PlayerMovement>();
        playerMovement.allowMove = false;
    }
    
    public void StartGame()
    {
        titleText.SetActive(false);
        startButton.SetActive(false);
        walkButton.SetActive(true);
        PlayerMovement playerMovement = chicken.GetComponent<PlayerMovement>();
        playerMovement.allowMove = true;
    }
}
