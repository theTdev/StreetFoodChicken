using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraTurnTriggerScript : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            other.GetComponent<PlayerMovement>().TurnCamera();
            Destroy(this.gameObject);
        }
    }
}
