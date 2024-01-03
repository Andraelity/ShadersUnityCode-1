using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerMovement : MonoBehaviour
{
     float playerHeight = 2f;

    [SerializeField] Transform orientation;

    [Header("Movement")]
    [SerializeField] float moveSpeed = 6f;
    [SerializeField] float airMultiplier = 0.4f;
    float movementMultiplier = 10f;

    [Header("Sprinting")]
    [SerializeField] float walkSpeed = 4f;
    [Range(0f, 15f)] public float walkSpeed_modifier = 4; 
    [SerializeField] float sprintSpeed = 6f;
    [Range(0f, 15f)] public float sprintSpeed_modifier = 6;
    [SerializeField] float acceleration = 10f;

    [Header("Jumping")]
    public float jumpForce = 5f;

    [Header("Keybinds")]
    [SerializeField] KeyCode jumpKey = KeyCode.Space;
    [SerializeField] KeyCode sprintKey = KeyCode.LeftShift;
    [SerializeField] KeyCode flyKey = KeyCode.LeftControl;    
    [SerializeField] bool keyCtrlState = false;

    [Header("Drag")]
    [SerializeField] float groundDrag = 6f;
    [SerializeField] float airDrag = 2f;

    float horizontalMovement;
    float verticalMovement;

    [Header("Ground Detection")]
    [SerializeField] Transform groundCheck;
    [SerializeField] LayerMask groundMask;
    [SerializeField] float groundDistance = 0.2f;
    public bool isGrounded { get; private set; }


    Vector3 moveDirection;
    Vector3 slopeMoveDirection;

    Rigidbody rb;

    RaycastHit slopeHit;

    private bool OnSlope()
    {
        if (Physics.Raycast(transform.position, Vector3.down, out slopeHit, playerHeight / 2 + 0.5f))
        {
            if (slopeHit.normal != Vector3.up)
            {
                return true;
            }
            else
            {
                return false;
            }
        }
        return false;
    }

    private void Start()
    {
        rb = GetComponent<Rigidbody>();
        rb.freezeRotation = true;
    }

    private void Update()
    {

        if(Input.GetKeyDown(flyKey))
        {
            keyCtrlState = !keyCtrlState;

            if(keyCtrlState == true)
            {
               rb.useGravity = false;                
            
            }
            if(keyCtrlState == false)
            {
               rb.useGravity = true;
            }

        }

        if(keyCtrlState == true)
        {
            MyInputFly();

            if (Input.GetKey(jumpKey))
            {
                FlyUp();
            }
            if (Input.GetKey(sprintKey))
            {
                FlyDown();
            }

        }

        if(keyCtrlState == false)
        {
            isGrounded = Physics.CheckSphere(groundCheck.position, groundDistance, groundMask);
            MyInput();
            ControlSpeed();
            ControlDrag();

            // print(isGrounded);
            if (Input.GetKeyDown(jumpKey) && isGrounded)
            {
                Jump();
            }
            
            slopeMoveDirection = Vector3.ProjectOnPlane(moveDirection, slopeHit.normal);
        
        }

    }

    void MyInputFly()
    {
        horizontalMovement = Input.GetAxisRaw("Horizontal");
        verticalMovement = Input.GetAxisRaw("Vertical");

        moveDirection = orientation.forward * verticalMovement + orientation.right * horizontalMovement;

        float adjustment = 0.05f;
        moveDirection = new Vector3(adjustment * moveDirection.x, adjustment * moveDirection.y, adjustment * moveDirection.z);
        transform.position = transform.position + (moveDirection);

    }


    void MyInput()
    {
        horizontalMovement = Input.GetAxisRaw("Horizontal");
        verticalMovement = Input.GetAxisRaw("Vertical");

        moveDirection = orientation.forward * verticalMovement + orientation.right * horizontalMovement;
    }
    
    void FlyUp()
    {
        transform.position += new Vector3(0f, 0.1f, 0f);         
    }
    
    void FlyDown()
    {
        transform.position -= new Vector3(0f, 0.1f, 0f); 
    }
    

    void Jump()
    {
        if (isGrounded)
        {
            rb.velocity = new Vector3(rb.velocity.x, 0, rb.velocity.z);
            rb.AddForce(transform.up * jumpForce, ForceMode.Impulse);
        }
    }

    void ControlSpeed()
    {
        if (Input.GetKey(sprintKey) && isGrounded)
        {
            moveSpeed = Mathf.Lerp(moveSpeed, sprintSpeed + sprintSpeed_modifier, acceleration * Time.deltaTime);
        }
        else
        {
            moveSpeed = Mathf.Lerp(moveSpeed, walkSpeed + walkSpeed_modifier, acceleration * Time.deltaTime);
        }
    }

    void ControlDrag()
    {
        if (isGrounded)
        {
            rb.drag = groundDrag;
        }
        else
        {
            rb.drag = airDrag;
        }
    }

    private void FixedUpdate()
    {
        if(keyCtrlState == false)
        {
            MovePlayer();
        }
    }

    void MovePlayer()
    {
        if (isGrounded && !OnSlope())
        {
            rb.AddForce(moveDirection.normalized * moveSpeed * movementMultiplier, ForceMode.Force);
        }
        else if (isGrounded && OnSlope())
        {
            rb.AddForce(slopeMoveDirection.normalized * moveSpeed * movementMultiplier, ForceMode.Force);
        }
        else if (!isGrounded)
        {
            rb.AddForce(((moveDirection.normalized * 0.2f) + (transform.up * -1f).normalized*0.2f) * moveSpeed * movementMultiplier * airMultiplier, ForceMode.Force);
            // rb.AddForce(((transform.up * -1).normalized*0.2f) * moveSpeed * movementMultiplier * airMultiplier, ForceMode.Force);

        }
    }
}