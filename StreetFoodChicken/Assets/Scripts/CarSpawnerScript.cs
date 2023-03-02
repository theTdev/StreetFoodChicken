using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class CarSpawnerScript : MonoBehaviour
{
    public GameObject[] carPrefabs;
    public bool reversed = false;

    private void Start()
    {
        StartCoroutine(SpawnCar());
    }

    IEnumerator SpawnCar()
    {
        while (true)
        {
            float nextSpawnTime = Random.Range(2, 4);
            GameObject car = Instantiate(carPrefabs[Random.Range(0, carPrefabs.Length)], transform.position,
                Quaternion.Euler(0, reversed ? 90 : -90, 0));
            car.GetComponent<CarDriveScript>().driveReverse = reversed;
            yield return new WaitForSeconds(nextSpawnTime);
        }
    }
}
