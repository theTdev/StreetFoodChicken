using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEditorInternal;
using UnityEngine;
using UnityEngine.SceneManagement;

public class UIManagement : MonoBehaviour
{
    public GameObject titleText;
    public GameObject startButton;
    public GameObject walkButton;
    public GameObject chicken;
    public GameObject invincibleButton;
    public GameObject deathScreen;
    public GameObject reviveButton;
    public GameObject highScoreText;
    public GameObject scorePanel;
    private bool performRestart = false;

    private void Start()
    {
        highScoreText.SetActive(true);
        highScoreText.GetComponent<TextMeshProUGUI>().SetText(PlayerPrefs.HasKey("Highscore") ? "Highscore: " + PlayerPrefs.GetFloat("Highscore") + " m" : "Highscore: 0 m");
        scorePanel.SetActive(false);
        reviveButton.SetActive(true);
        deathScreen.SetActive(false);
        titleText.SetActive(true);
        startButton.SetActive(true);
        walkButton.SetActive(false);
        PlayerMovement playerMovement = chicken.GetComponent<PlayerMovement>();
        playerMovement.allowMove = false;
        invincibleButton.SetActive(false);
    }

    public void EnableDeathScreen(bool reviveEnabled)
    {
        scorePanel.SetActive(false);
        if (deathScreen.activeSelf) return;
        invincibleButton.SetActive(false);
        deathScreen.SetActive(true);
        reviveButton.SetActive(reviveEnabled);

        if (reviveEnabled)
        {
            performRestart = true;
            StartCoroutine(StartCountDownTimer(5));
        }
        else StartCoroutine(RestartTheGame());
    }

    IEnumerator RestartTheGame()
    {
        yield return new WaitForSeconds(3);
        SceneManager.LoadScene("Main");
    }

    public void Revive()
    {
        scorePanel.SetActive(true);
        performRestart = false;
        deathScreen.SetActive(false);
        chicken.GetComponent<PlayerMovement>().RestartGoInvincible();
    }

    IEnumerator StartCountDownTimer(int time)
    {
        while (time >= 0)
        {
            reviveButton.GetComponent<TextMeshProUGUI>().SetText("Revive " + "(" + time + "s)");
            time--;
            yield return new WaitForSeconds(1);
        }

        if (performRestart)
        {
            RestartNow();
        }
    }

    public void RestartNow()
    {
        SceneManager.LoadScene("Main");
    }
    
    public void StartGame()
    {
        highScoreText.SetActive(false);
        scorePanel.SetActive(true);
        invincibleButton.SetActive(false);
        titleText.SetActive(false);
        startButton.SetActive(false);
        walkButton.SetActive(true);
        PlayerMovement playerMovement = chicken.GetComponent<PlayerMovement>();
        playerMovement.allowMove = true;
    }
}
