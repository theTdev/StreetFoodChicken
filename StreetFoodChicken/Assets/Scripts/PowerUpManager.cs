using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PowerUpManager : MonoBehaviour
{
    public GameObject powerUpPanel;
    public GameObject[] powerUpImages;

    private void Start()
    {
        DisableAllPowerUps();
        powerUpPanel.SetActive(false);
    }
    
    public void EnablePowerUpPanel()
    {
        powerUpPanel.SetActive(true);
    }

    public void DisableAllPowerUps()
    {
        DisablePowerUp(0);
        DisablePowerUp(1);
        DisablePowerUp(2);
    }

    public void EnablePowerUp(int num)
    {
        powerUpImages[num].SetActive(true);
    }

    public void DisablePowerUp(int num)
    {
        powerUpImages[num].SetActive(false);
    }

    public void UpdateChickensAmount(int amount)
    {
        Debug.Log("Amount: " + amount);
        if (amount > 2)
        {
            EnablePowerUp(0);
        } else DisablePowerUp(0);
        
        if (amount > 3)
        {
            
            EnablePowerUp(1);
        } else DisablePowerUp(1);
        
        if (amount > 4)
        {
            EnablePowerUp(2);
        } else DisablePowerUp(2);
    }
}
