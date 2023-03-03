using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

namespace DistantLands.Utility
{
    public class DemoManager : MonoBehaviour
    {
        public int nextScene;


        // Start is called before the first frame update
        void Start()
        {

        }

        // Update is called once per frame
        void Update()
        {

            if (Input.GetKeyUp(KeyCode.Space))
                SceneManager.LoadScene(nextScene);

        }
    }
}