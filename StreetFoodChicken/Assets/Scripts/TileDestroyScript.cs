using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileDestroyScript : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Destroy(gameObject.transform.parent.gameObject);
        }
    }
}
