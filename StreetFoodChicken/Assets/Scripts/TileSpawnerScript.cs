using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileSpawnerScript : MonoBehaviour
{
    public GameObject tilePrefab;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Vector3 spawnPos = new Vector3(transform.position.x + 35F, 0F, transform.position.z);
            GameObject gameObject = Instantiate(tilePrefab, spawnPos, Quaternion.identity);
            gameObject.name = "Tile";
            Destroy(this.gameObject);
        }
    }
}
