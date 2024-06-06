Team Sputnik I
Here is our name and the API we are testing, this git include the codes that api we have tested succesfully. To see output  we need to go to console and run.


By JeongHun Song	1
2.1. portSWITCH_TO_USER_MODE()	1
2.2. vTaskAllocateMPURegions()	1
2.3. xTaskAbortDelay()	1
2.4.xTaskCallApplicationTaskHook()	2
2.5. xTaskCheckFortimeOut()	4
2.6. xTaskCreate()	5
2.7. xTaskCreateStatic()	6
2.8. xTaskCreateRestricted()	7
2.9. vTaskDelay()	7
2.10. vTaskDelayUntil()	8
2.53. vTaskSuspend()	9
by Nishant Chaulagai  (11-20)	11
2.11 VTaskDelayUntil	11
2.12 VTaskDelete()	13
2.13 TaskDisable_INTERRUPTS()	15
2.14 Taskenter_Critical()	17
By Arnab (21-30)	19
2.21 xTask GetHandle	19
2.22 uxTaskGetNumberOfTasks()	21
2.23 vTaskGetRunTimeStats ( Not working)	22
2.24 xTaskGetSchedulerState()	22
2.25 vTaskStartScheduler()	23
2.26 eTaskGetState()	25
2.27 uxTaskGetSystemState=vTaskStartSchedule	27
2.28 vTaskGetInfo()	29
2.29 vTaskSetThreadLocalStoragePointer	30
2.30 pcTaskGetName()	32
2.52 vTaskStepTick() - not working	34
by Ekaterina B.	34
2.31. xTaskGetTickCount()	34
2.32 xTaskGetTickCountFromISR()	35
2.33 xTaskList()	37
2.34 xTaskNotify()	39
2.35. xTaskNotifyAndQuery()	41
2.36 xTaskNotifyAndQueryFromISR()	43
2.37 xTaskNotifyFromISR()	46
2.38. xTaskNotifyGive()	48
2.39 xTaskNotifyGiveFromISR()	50
2.40 xTaskNotifyStateClear()	53
2.55 taskYIELD()	55
By Nyan Lin Maung Maung	57
2.46 xTaskResumeAll()	57
2.41 ulTaskNotifyTake()	59
2.42 xTaskNotifyWait()	62
2.43 uxTaskPriorityGet()	65
2.44 vTaskPrioritySet()	68
2.45 vTaskResume()	71
2.47 xTaskResumeFromISR()	74
2.48 vTaskSetApplicationTaskTag()	76
2.49 vTaskSetThreadLocalStoragePointer()	78
2.50 vTaskSetTimeOutState()	80
2.51  vTaskStartScheduler()	83

By JeongHun Song
2.1. portSWITCH_TO_USER_MODE()		
don’t working need MPU port

2.2. vTaskAllocateMPURegions()		
don’t working need MPU port

2.3. xTaskAbortDelay() 
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

void vAbortDelayTask(void* pvParameters) {
           
        const TickType_t xDelay1000ms = pdMS_TO_TICKS(1000);
        BaseType_t xAbortSelf = pdFALSE;

        for (;;)
        {
            
            vTaskDelay(xDelay1000ms);

            if (xAbortSelf == pdFALSE)
            {
                xAbortSelf = pdTRUE;
            }
            else
            {
                
                xTaskAbortDelay(vAbortDelayTask);
                
                xAbortSelf = pdFALSE;
                printf("Task self-aborted delay. 202010114 SongJeongHun\n");
            }
        }
    
}
int main(void) {
   
  
    xTaskCreate(vAbortDelayTask, "Second Task", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 2, NULL);
    

    vTaskStartScheduler();

    for (;;) {    }

    return 0;
}

void vApplicationGetIdleTaskMemory(StaticTask_t** ppxIdleTaskTCBBuffer, StackType_t** ppxIdleTaskStackBuffer, uint32_t* pulIdleTaskStackSize)
{

    static StaticTask_t xIdleTaskTCB;
    static StackType_t uxIdleTaskStack[configMINIMAL_STACK_SIZE];

    *ppxIdleTaskTCBBuffer = &xIdleTaskTCB;

    *ppxIdleTaskStackBuffer = uxIdleTaskStack;

    *pulIdleTaskStackSize = configMINIMAL_STACK_SIZE;
}




2.4.xTaskCallApplicationTaskHook()
#define traceTASK_SWITCHED_OUT() xTaskCallApplicationTaskHook(pxCurrentTCB, 0)

void xWriteTrace(const char* pcTaskName) {

    printf("Task switched out: %s\n", pcTaskName); }

static BaseType_t prvExampleTaskHook(void* pvParameter) {

    TaskHandle_t xTaskHandle = xTaskGetCurrentTaskHandle();

    const char* pcTaskName = pcTaskGetName(xTaskHandle);

    xWriteTrace(pcTaskName);

    return 0; }

void xHookTask(void* pvParameters) {
    
    vTaskSetApplicationTaskTag(NULL, prvExampleTaskHook);

    for (;;) {

        printf("First task is going to sleep.\n");
        vTaskDelay(pdMS_TO_TICKS(1000));
        printf("Hook task running\n");
        printf("202010114 Song JeongHun\n");
        vTaskDelay(200);  }
}

int main(void) {
      xTaskCreate(xHookTask, "Task Hook", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, &xFirstTaskHandle);
    
     vTaskStartScheduler();

    for (;;) {    }

    return 0;
}



2.5. xTaskCheckFortimeOut() 
void vCheckTimeOutTask(void* pvParameters) {
    TimeOut_t xTimeOut;
    TickType_t xTicksToWait = pdMS_TO_TICKS(5000); 

    vTaskSetTimeOutState(&xTimeOut);
    printf("202010114 Song JeongHun\n");
    printf("Check timeout task starting...\n");

    while (1) {
        
        printf("Check timeout task working...\n");
        printf("202010114 SongJeongHun\n");

        vTaskDelay(pdMS_TO_TICKS(1000));

        if (xTaskCheckForTimeOut(&xTimeOut, &xTicksToWait) != pdFALSE) {
            printf("Check timeout task timed out.\n");
            printf("202010114 SongJeongHun\n");
            
            break;
        }
    }
    vTaskDelete(NULL);
}

int main(void) {
       xTaskCreate(vCheckTimeOutTask, "Check Timeout Task", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 3, &xCheckTimeOutTaskHandle);
 
      vTaskStartScheduler();
    for (;;) {    }
    return 0;
}


2.6. xTaskCreate() 
void vTaskCreate(void* pvParameters) {
    const char* pcTaskName = (const char*)pvParameters;
    TickType_t xLastWakeTime;
    const TickType_t xFrequency = 1000 / portTICK_PERIOD_MS;

    xLastWakeTime = xTaskGetTickCount();

    for (;;) {
        
        printf("202010114 Song JeongHun\n");
        printf("%s\n", pcTaskName);

        vTaskDelayUntil(&xLastWakeTime, xFrequency);
    }
}

int main(void) {
       xTaskCreate(vTaskCreate, "Task Create", configMINIMAL_STACK_SIZE, (void*)"Task Create is running", tskIDLE_PRIORITY + 4, NULL);
    vTaskStartScheduler();

    for (;;) {    }

    return 0;
}



2.7. xTaskCreateStatic()  
#define STACK_SIZE 128
static StackType_t xStack[STACK_SIZE];
static StaticTask_t xTaskBuffer;

void vStaticCreateTask(void* pvParameters)
{
    const char* msg = "Hello from Static Create Task!\r\n";
    for (;;)
    {
        printf("%s", msg);
        printf("202010114 SongJeongHun\n");
        vTaskDelay(pdMS_TO_TICKS(2000)); 
    }
}

void vApplicationGetIdleTaskMemory(StaticTask_t** ppxIdleTaskTCBBuffer, StackType_t** ppxIdleTaskStackBuffer, uint32_t* pulIdleTaskStackSize)
{
    
    static StaticTask_t xIdleTaskTCB;
    static StackType_t uxIdleTaskStack[configMINIMAL_STACK_SIZE];

    *ppxIdleTaskTCBBuffer = &xIdleTaskTCB;

    *ppxIdleTaskStackBuffer = uxIdleTaskStack;

    *pulIdleTaskStackSize = configMINIMAL_STACK_SIZE;
}
int main(void) {
    TaskHandle_t xHandle = xTaskCreateStatic(vStaticCreateTask, "Static Create Task", STACK_SIZE, NULL, tskIDLE_PRIORITY + 5, xStack, &xTaskBuffer);
    
    vTaskStartScheduler();

    
    for (;;) {    }

    return 0;
}

	
2.8. xTaskCreateRestricted()  	
don’t working need MPU port

2.9. vTaskDelay()  
void vDelayTask(void* pvParameters)
{
    const char* msg = "Delay by 5s Task!\r\n";
    for (;;)
    {
        printf("%s", msg);
        printf("202010114 SongJeongHun\n");
        vTaskDelay(pdMS_TO_TICKS(5000)); 
    }
}
int main(void) {
    //xTaskCreate(vDelayTask, "Delay Task", configMINIMAL_STACK_SIZE, NULL, 
    vTaskStartScheduler();

    for (;;) {    }
    return 0;}


2.10. vTaskDelayUntil()  
void vTaskDelayUntilTask(void* pvParameters)
{
    TickType_t xLastWakeTime;
    const TickType_t xFrequency = pdMS_TO_TICKS(3000);  
    xLastWakeTime = xTaskGetTickCount();

    for (;;)
    {
        printf("vTaskDelayUntil task running at %d ticks 202010114 SongJeongHun\n", xLastWakeTime);
        vTaskDelayUntil(&xLastWakeTime, xFrequency);
    }
}

int main(void) {
    xTaskCreate(vTaskDelayUntilTask, "DelayUntil Task", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 6, NULL);

    vTaskStartScheduler();

    for (;;) {    }

    return 0;
}

2.53. vTaskSuspend()
TaskHandle_t xTask1Handle = NULL;
TaskHandle_t xTask2Handle = NULL;

void vTask1(void* pvParameters) {
    for (;;) {
        printf("Task 1 is running\n");
        vTaskDelay(pdMS_TO_TICKS(1000)); 
    }
}

void vTask2(void* pvParameters) {
    for (;;) {
        printf("Task 2 is running\n");
        vTaskDelay(pdMS_TO_TICKS(1000)); 
    }
}

void vControlTask(void* pvParameters) {
    for (;;) {
        printf("Suspending Task 1\n");
        vTaskSuspend(xTask1Handle); 
        vTaskDelay(pdMS_TO_TICKS(5000)); 

        printf("Resuming Task 1\n");
        vTaskResume(xTask1Handle); 
        vTaskDelay(pdMS_TO_TICKS(5000));     }
}

int main(void) {

    xTaskCreate(vTask1, "Task 1", configMINIMAL_STACK_SIZE, NULL, 1, &xTask1Handle);
    xTaskCreate(vTask2, "Task 2", configMINIMAL_STACK_SIZE, NULL, 1, &xTask2Handle);
    xTaskCreate(vControlTask, "Control Task", configMINIMAL_STACK_SIZE, NULL, 2, NULL);

    vTaskStartScheduler();

    for (;;) {
    }
}

  


by Nishant Chaulagai  (11-20)
2.11 VTaskDelayUntil
code : #include <FreeRTOS.h>
#include <task.h>
#include <stdio.h>

// Define the stack size and priority of the tasks
#define STACK_SIZE 200
#define TASK1_PRIORITY 1
#define TASK2_PRIORITY 2

// Task handles
TaskHandle_t task1Handle = NULL;
TaskHandle_t task2Handle = NULL;

// Function prototypes
void vTask1(void* pvParameters);
void vTask2(void* pvParameters);

int main(void)
{
    // Create the tasks
    xTaskCreate(vTask1, "Task1", STACK_SIZE, NULL, TASK1_PRIORITY, &task1Handle);
    xTaskCreate(vTask2, "Task2", STACK_SIZE, NULL, TASK2_PRIORITY, &task2Handle);

    // Start the scheduler
    vTaskStartScheduler();

    // The program should never reach here as the scheduler is now running
    for (;;);

    return 0;
}

void vTask1(void* pvParameters)
{
    TickType_t xLastWakeTime;
    const TickType_t xFrequency = 1000 / portTICK_PERIOD_MS;

    // Initialize the xLastWakeTime variable with the current time
    xLastWakeTime = xTaskGetTickCount();

    for (;;)
    {
        // Print a message
        printf("Task 1 is running\n");

        // Delay for a period
        vTaskDelayUntil(&xLastWakeTime, xFrequency);
    }
}

void vTask2(void* pvParameters)
{
    TickType_t xLastWakeTime;
    const TickType_t xFrequency = 500 / portTICK_PERIOD_MS;

    // Initialize the xLastWakeTime variable with the current time
    xLastWakeTime = xTaskGetTickCount();

    for (;;)
    {
        // Print a message
        printf("Task 2 is running\n");

        // Delay for a period
        vTaskDelayUntil(&xLastWakeTime, xFrequency);
    }
}



2.12 VTaskDelete()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

void TaskFunction(void* pvParameters);

int main(void) {
    printf("Starting FreeRTOS application\n");

    if (xTaskCreate(TaskFunction, "Task", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL) != pdPASS) {
        printf("Task creation failed!\n");
        return 1; 
    }

    vTaskStartScheduler();

    printf("Failed to start the scheduler. Out of heap memory?\n");
    return 2; 
}

void TaskFunction(void* pvParameters) {
    (void) pvParameters; 
    vTaskDelete(NULL);

    for (;;);
}





2.13 TaskDisable_INTERRUPTS()
code : #include <FreeRTOS.h>
#include <task.h>
#include <stdio.h>

// Define the stack size and priority of the tasks
#define STACK_SIZE 200
#define TASK1_PRIORITY 1
#define TASK2_PRIORITY 2

// Task handles
TaskHandle_t task1Handle = NULL;
TaskHandle_t task2Handle = NULL;

// Function prototypes
void vTask1(void *pvParameters);
void vTask2(void *pvParameters);

int main(void)
{
    // Create the tasks
    xTaskCreate(vTask1, "Task1", STACK_SIZE, NULL, TASK1_PRIORITY, &task1Handle);
    xTaskCreate(vTask2, "Task2", STACK_SIZE, NULL, TASK2_PRIORITY, &task2Handle);

    // Start the scheduler
    vTaskStartScheduler();

    // The program should never reach here as the scheduler is now running
    for (;;);

    return 0;
}

void vTask1(void *pvParameters)
{
    for (;;)
    {
        // Print a message
        printf("Task 1 is running and will disable interrupts\n");

        // Disable interrupts
        taskDISABLE_INTERRUPTS();

        // Perform critical section operations
        printf("Task 1 is performing critical section operations\n");

        // Simulate some work in the critical section
        for (volatile int i = 0; i < 1000000; i++);

        // Enable interrupts
        taskENABLE_INTERRUPTS();

        // Print a message
        printf("Task 1 has re-enabled interrupts\n");

        // Simulate some work outside the critical section
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

void vTask2(void *pvParameters)
{
    for (;;)
    {
        // Print a message
        printf("Task 2 is running\n");

        // Simulate some work
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}



2.14 Taskenter_Critical()
code : #include <FreeRTOS.h>
#include <task.h>
#include <stdio.h>

// Define the stack size and priority of the tasks
#define STACK_SIZE 200
#define TASK1_PRIORITY 1
#define TASK2_PRIORITY 2

// Task handles
TaskHandle_t task1Handle = NULL;
TaskHandle_t task2Handle = NULL;

// Function prototypes
void vTask1(void *pvParameters);
void vTask2(void *pvParameters);

int main(void)
{
    // Create the tasks
    xTaskCreate(vTask1, "Task1", STACK_SIZE, NULL, TASK1_PRIORITY, &task1Handle);
    xTaskCreate(vTask2, "Task2", STACK_SIZE, NULL, TASK2_PRIORITY, &task2Handle);

    // Start the scheduler
    vTaskStartScheduler();

    // The program should never reach here as the scheduler is now running
    for (;;);

    return 0;
}

void vTask1(void *pvParameters)
{
    for (;;)
    {
        // Print a message
        printf("Task 1 is running and will enter critical section\n");

        // Enter critical section
        taskENTER_CRITICAL();

        // Perform critical section operations
        printf("Task 1 is performing critical section operations\n");

        // Simulate some work in the critical section
        for (volatile int i = 0; i < 1000000; i++);

        // Exit critical section
        taskEXIT_CRITICAL();

        // Print a message
        printf("Task 1 has exited critical section\n");

        // Simulate some work outside the critical section
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}

void vTask2(void *pvParameters)
{
    for (;;)
    {
        // Print a message
        printf("Task 2 is running\n");

        // Simulate some work
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}



—---------------------------------------------------------------------------


By Arnab (21-30)
2.21 xTaskGetHandle
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTaskBlink(void* pvParameters);
void vTaskPrint(void* pvParameters);

// Main function
int main(void)
{
	// Create tasks
	xTaskCreate(vTaskBlink, "Blink", 1000, NULL, 1, NULL);
	xTaskCreate(vTaskPrint, "Print", 1000, NULL, 1, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop
	while (1);
	return 0;
}

// Task to simulate an LED blinking
void vTaskBlink(void* pvParameters)
{
	const TickType_t xDelay = 500 / portTICK_PERIOD_MS;

	for (;;)
	{
    	printf("LED ON\n");
    	vTaskDelay(xDelay);  // Delay for a period of time

    	printf("LED OFF\n");
    	vTaskDelay(xDelay);  // Delay for a period of time
	}
}

// Task to print a message
void vTaskPrint(void* pvParameters)
{
	const TickType_t xDelay = 1000 / portTICK_PERIOD_MS;

	for (;;)
	{
    	printf("Hello from FreeRTOS!\n");
    	vTaskDelay(xDelay);  // Delay for a period of time
	}
}


2.22 uxTaskGetNumberOfTasks()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTaskMonitor(void* pvParameters);
void vTaskWorker(void* pvParameters);

// Main function
int main(void)
{
	// Create tasks
	xTaskCreate(vTaskWorker, "Worker1", 1000, NULL, 1, NULL);
	xTaskCreate(vTaskWorker, "Worker2", 1000, NULL, 1, NULL);
	xTaskCreate(vTaskMonitor, "Monitor", 1000, NULL, 2, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop
	while (1);
	return 0;
}

// Task to monitor and report the number of tasks rapidly
void vTaskMonitor(void* pvParameters)
{
	const TickType_t xDelay = 200 / portTICK_PERIOD_MS;  // Adjusted to 200 ms

	for (;;)
	{
    	UBaseType_t uxTasks = uxTaskGetNumberOfTasks();
    	printf("Total number of running tasks: %u\n", uxTasks);
    	vTaskDelay(xDelay);  // Short delay
	}
}

// Worker task that does minimal work
void vTaskWorker(void* pvParameters)
{
	const TickType_t xDelay = 500 / portTICK_PERIOD_MS;  // Every 500 ms

	for (;;)
	{
    	printf("%s is running\n", pcTaskGetName(NULL));
    	vTaskDelay(xDelay);  // Delay for half a second
	}
}

2.23 vTaskGetRunTimeStats ( Not working)

2.24 xTaskGetSchedulerState()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task prototypes
void vTaskCheckScheduler(void* pvParameters);

int main(void)
{
	// Create a task
	xTaskCreate(vTaskCheckScheduler, "SchedulerChecker", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop (should never reach here)
	while (1);
	return 0;
}

// Task to check and print the scheduler state
void vTaskCheckScheduler(void* pvParameters)
{
	for (;;)
	{
    	// Get the current state of the scheduler
    	switch (xTaskGetSchedulerState()) {
    	case taskSCHEDULER_RUNNING:
        	printf("Scheduler is running.\n");
        	break;
    	case taskSCHEDULER_SUSPENDED:
        	printf("Scheduler is suspended.\n");
        	break;
    	case taskSCHEDULER_NOT_STARTED:
        	printf("Scheduler has not started.\n");
        	break;
    	default:
        	printf("Unknown state.\n");
        	break;
    	}

    	// Delay for a second
    	vTaskDelay(pdMS_TO_TICKS(1000));
	}
}



2.25 vTaskStartScheduler()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTask1(void *pvParameters);
void vTask2(void *pvParameters);

int main(void)
{
	// Create tasks
	xTaskCreate(vTask1, "Task 1", 1000, NULL, 1, NULL);
	xTaskCreate(vTask2, "Task 2", 1000, NULL, 2, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop (should never be reached)
	while(1);
	return 0;
}

// Task 1 performs a simple print and delay loop
void vTask1(void *pvParameters)
{
	for (;;)
	{
    	printf("Task 1 is running\n");
    	vTaskDelay(pdMS_TO_TICKS(1000)); // Delay for 1 second
	}
}

// Task 2 performs a simple print and delay loop
void vTask2(void *pvParameters)
{
	for (;;)
	{
    	printf("Task 2 is running\n");
    	vTaskDelay(pdMS_TO_TICKS(500)); // Delay for 500 ms
	}
}



2.26 eTaskGetState()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTaskWorker(void *pvParameters);
void vTaskMonitor(void *pvParameters);

// Handle for the worker task
TaskHandle_t xTaskWorkerHandle = NULL;

int main(void)
{
	// Create tasks
	xTaskCreate(vTaskWorker, "Worker", 1000, NULL, 1, &xTaskWorkerHandle);
	xTaskCreate(vTaskMonitor, "Monitor", 1000, NULL, 2, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop (should never reach here)
	while(1);
	return 0;
}

// Worker task that toggles its state between running and blocked
void vTaskWorker(void *pvParameters)
{
	TickType_t xLastWakeTime;
	const TickType_t xDelay = pdMS_TO_TICKS(2000); // 2-second delay

	// Initialize the xLastWakeTime variable with the current time.
	xLastWakeTime = xTaskGetTickCount();

	for (;;)
	{
    	printf("Worker task is running.\n");
    	// Delay for the next cycle.
    	vTaskDelayUntil(&xLastWakeTime, xDelay);
	}
}

// Monitor task to check and print the state of the worker task
void vTaskMonitor(void *pvParameters)
{
	for (;;)
	{
    	// Get the state of the worker task
    	eTaskState xTaskState = eTaskGetState(xTaskWorkerHandle);

    	// Print the state
    	switch (xTaskState) {
        	case eRunning:
            	printf("Worker task state: RUNNING\n");
            	break;
        	case eReady:
            	printf("Worker task state: READY\n");
            	break;
        	case eBlocked:
            	printf("Worker task state: BLOCKED\n");
            	break;
        	case eSuspended:
            	printf("Worker task state: SUSPENDED\n");
            	break;
        	case eDeleted:
            	printf("Worker task state: DELETED\n");
            	break;
        	default:
            	printf("Worker task state: UNKNOWN\n");
            	break;
    	}

    	// Delay for 1 second
    	vTaskDelay(pdMS_TO_TICKS(1000));
	}
}



2.27 uxTaskGetSystemState=vTaskStartSchedule
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTask1(void *pvParameters);
void vTask2(void *pvParameters);

int main(void)
{
	// Create tasks
	xTaskCreate(vTask1, "LED1 Toggle", 1000, NULL, 1, NULL);
	xTaskCreate(vTask2, "LED2 Toggle", 1000, NULL, 1, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop (should never reach here)
	while(1);
	return 0;
}

void vTask1(void *pvParameters)
{
	TickType_t xLastWakeTime = xTaskGetTickCount(); // Initialise the xLastWakeTime variable with the current time.
	for (;;)
	{
    	printf("LED 1 ON\n");
    	vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(1000));
    	printf("LED 1 OFF\n");
    	vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(1000));
	}
}

void vTask2(void *pvParameters)
{
	TickType_t xLastWakeTime = xTaskGetTickCount(); // Initialise the xLastWakeTime variable with the current time.
	for (;;)
	{
    	printf("LED 2 ON\n");
    	vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(500));
    	printf("LED 2 OFF\n");
    	vTaskDelayUntil(&xLastWakeTime, pdMS_TO_TICKS(500));
	}
}



2.28 vTaskGetInfo()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTask1(void *pvParameters);
void vTask2(void *pvParameters);

int main(void)
{
	// Create tasks
	xTaskCreate(vTask1, "Task 1", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
	xTaskCreate(vTask2, "Task 2", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// We should never reach here
	while(1);
	return 0;
}

void vTask1(void *pvParameters)
{
	for (;;)
	{
    	printf("Task 1 is running\n");
    	vTaskDelay(pdMS_TO_TICKS(1000));  // Delay for 1 second
	}
}

void vTask2(void *pvParameters)
{
	for (;;)
	{
    	printf("Task 2 is running\n");
    	vTaskDelay(pdMS_TO_TICKS(500));  // Delay for 500 milliseconds
	}
}



2.29 vTaskSetThreadLocalStoragePointer
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTaskPrint1(void *pvParameters);
void vTaskPrint2(void *pvParameters);

int main(void)
{
	// Create tasks
	xTaskCreate(vTaskPrint1, "Print Task 1", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
	xTaskCreate(vTaskPrint2, "Print Task 2", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop (should never be reached)
	while(1);
	return 0;
}

void vTaskPrint1(void *pvParameters)
{
	for (;;)
	{
    	printf("Task 1: Running\n");
    	vTaskDelay(pdMS_TO_TICKS(1000));  // Delay for 1 second
	}
}

void vTaskPrint2(void *pvParameters)
{
	for (;;)
	{
    	printf("Task 2: Running\n");
    	vTaskDelay(pdMS_TO_TICKS(500));  // Delay for 500 milliseconds
	}
}



2.30 pcTaskGetName()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task function prototypes
void vTask1(void* pvParameters);
void vTask2(void* pvParameters);

int main(void)
{
	// Create tasks
	xTaskCreate(vTask1, "Task 1", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
	xTaskCreate(vTask2, "Task 2", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

	// Start the scheduler
	vTaskStartScheduler();

	// Infinite loop (should never be reached)
	while (1);
	return 0;
}

void vTask1(void* pvParameters)
{
	TaskHandle_t xHandle = xTaskGetCurrentTaskHandle();

	for (;;)
	{
    	// Retrieve and print the task name
    	printf("API testing: %s\n", pcTaskGetName(xHandle));
    	vTaskDelay(pdMS_TO_TICKS(1000));  // Delay for 1 second
	}
}

void vTask2(void* pvParameters)
{
	TaskHandle_t xHandle = xTaskGetCurrentTaskHandle();

	for (;;)
	{
    	// Retrieve and print the task name
    	printf("API tested by AB: %s\n", pcTaskGetName(xHandle));
    	vTaskDelay(pdMS_TO_TICKS(500));  // Delay for 500 milliseconds
	}
}

2.52 vTaskStepTick() - not working



by Ekaterina B.
2.31. xTaskGetTickCount()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

void TickCounterTask(void *pvParameters);

int main(void) {

    printf("Ekaterina Breslavskaya 202212147\n");
    fflush(stdout);  
    BaseType_t xReturned;
    TaskHandle_t xHandle = NULL;

    xReturned = xTaskCreate(
        TickCounterTask,            
        "TickCounter",              
        configMINIMAL_STACK_SIZE,   
        NULL,                       
        1,                          
        &xHandle                    
    );

    if (xReturned == pdPASS) {
        vTaskStartScheduler();
    } else {
        printf("Task creation failed!\n");
        fflush(stdout);
    }

    for (;;);
}

void TickCounterTask(void *pvParameters) {
    TickType_t xLastWakeTime;
    const TickType_t xFrequency = pdMS_TO_TICKS(1000); 

    xLastWakeTime = xTaskGetTickCount();

    while (1) {
        vTaskDelayUntil(&xLastWakeTime, xFrequency);

        TickType_t tickCount = xTaskGetTickCount();
        printf("Current tick count: %u\n", (unsigned int) tickCount);
        printf("Ekaterina Breslavskaya 202212147\n"); 
        fflush(stdout); 
    }
}


2.32 xTaskGetTickCountFromISR()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

void ISR_Simulator_Task(void *pvParameters);
void Regular_Task(void *pvParameters);

int main(void) {
    printf("Ekaterina Breslavskaya 202212147. Task 2.32\n");

    
    xTaskCreate(ISR_Simulator_Task, "ISR Simulator", configMINIMAL_STACK_SIZE, NULL, 2, NULL);
    xTaskCreate(Regular_Task, "Regular Task", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

    vTaskStartScheduler();

    for (;;);
}

void ISR_Simulator_Task(void *pvParameters) {
    TickType_t xLastWakeTime;
    const TickType_t xFrequency = pdMS_TO_TICKS(2000); 

    xLastWakeTime = xTaskGetTickCount();

    while (1) {
        vTaskDelayUntil(&xLastWakeTime, xFrequency);

        TickType_t tickCount = xTaskGetTickCountFromISR();
        printf("Tick count from ISR context: %u\n", (unsigned int)tickCount);
        printf("Ekaterina Breslavskaya 202212147. Task 2.32\n");
    }
}

void Regular_Task(void *pvParameters) {
    TickType_t xLastWakeTime;
    const TickType_t xFrequency = pdMS_TO_TICKS(1000); 

    xLastWakeTime = xTaskGetTickCount();

    while (1) {
        vTaskDelayUntil(&xLastWakeTime, xFrequency);

        printf("Regular task tick count: %u\n", (unsigned int)xTaskGetTickCount());
    }
}




2.33 xTaskList()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

void TaskListDisplayTask(void *pvParameters);
void SampleTask(void *pvParameters);

#define TASK_LIST_BUFFER_SIZE 1024

int main(void) {
    printf("Ekaterina Breslavskaya 202212147\n");
    xTaskCreate(TaskListDisplayTask, "TaskListDisplay", configMINIMAL_STACK_SIZE * 2, NULL, 2, NULL);
    xTaskCreate(SampleTask, "SampleTask", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
    vTaskStartScheduler();
    for (;;);
}

void TaskListDisplayTask(void *pvParameters) {
    char *pcTaskListBuffer;
    pcTaskListBuffer = pvPortMalloc(TASK_LIST_BUFFER_SIZE); 
    if (pcTaskListBuffer == NULL) {
        printf("Failed to allocate buffer for task list.\n");
        vTaskDelete(NULL); 
    }

    while (1) {
        vTaskList(pcTaskListBuffer);
        
        printf("%s\n", pcTaskListBuffer);
        printf("Ekaterina Breslavskaya 202212147\n");

        vTaskDelay(pdMS_TO_TICKS(5000));
    }

    vPortFree(pcTaskListBuffer); // Clean up the allocated buffer if ever exiting the loop
}

void SampleTask(void *pvParameters) {
    while (1) {
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}



2.34 xTaskNotify()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task Handlers
TaskHandle_t notifierTaskHandle = NULL;
TaskHandle_t notifiedTaskHandle = NULL;

// Task Function Prototypes
void NotifierTask(void *pvParameters);
void NotifiedTask(void *pvParameters);

int main(void) {
    // Display the initial message
    printf("Ekaterina Breslavskaya 202212147\n");

    // Create tasks
    xTaskCreate(NotifierTask, "Notifier", configMINIMAL_STACK_SIZE, NULL, 2, &notifierTaskHandle);
    xTaskCreate(NotifiedTask, "Notified", configMINIMAL_STACK_SIZE, NULL, 1, &notifiedTaskHandle);

    // Start the scheduler
    vTaskStartScheduler();

    // If the scheduler starts, the following line should never be reached.
    for (;;) ;
    return 0;
}

void NotifierTask(void *pvParameters) {
    while (1) {
        vTaskDelay(pdMS_TO_TICKS(1000)); // Delay for 1 second
        // Send a simple notification to NotifiedTask
        xTaskNotify(notifiedTaskHandle, 0, eNoAction); // No value being sent, just a notification
    }
}

void NotifiedTask(void *pvParameters) {
    uint32_t ulNotificationValue;

    while (1) {
        // Wait indefinitely for a notification
        if (xTaskNotifyWait(0x00, ULONG_MAX, &ulNotificationValue, portMAX_DELAY) == pdPASS) {
            // Print the message upon receiving any notification
            printf("Ekaterina Breslavskaya 202212147\n");
        }
    }
}



2.35. xTaskNotifyAndQuery()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task Handlers
TaskHandle_t notifierTaskHandle = NULL;
TaskHandle_t notifiedTaskHandle = NULL;

// Task Function Prototypes
void NotifierTask(void *pvParameters);
void NotifiedTask(void *pvParameters);

int main(void) {
    // Display the initial message
    printf("Ekaterina Breslavskaya 202212147\n");

    // Create tasks
    xTaskCreate(NotifierTask, "Notifier", configMINIMAL_STACK_SIZE, NULL, 2, &notifierTaskHandle);
    xTaskCreate(NotifiedTask, "Notified", configMINIMAL_STACK_SIZE, NULL, 1, &notifiedTaskHandle);

    // Start the scheduler
    vTaskStartScheduler();

    // If the scheduler starts, the following line should never be reached.
    for (;;) ;
    return 0;
}

void NotifierTask(void *pvParameters) {
    uint32_t ulValueToSend = 10;  // Example value to send
    uint32_t ulPreviousNotificationValue = 0;

    while (1) {
        vTaskDelay(pdMS_TO_TICKS(1000)); // Delay for 1 second
        
        // Send a notification and query the previous notification value
        xTaskNotifyAndQuery(notifiedTaskHandle, ulValueToSend, eSetValueWithOverwrite, &ulPreviousNotificationValue);
        
        // Optionally print the previous notification value received by the task
        printf("Previous notification value was: %lu\n", ulPreviousNotificationValue);
    }
}

void NotifiedTask(void *pvParameters) {
    uint32_t ulNotificationValue;

    while (1) {
        // Wait indefinitely for a notification
        if (xTaskNotifyWait(0x00, ULONG_MAX, &ulNotificationValue, portMAX_DELAY) == pdPASS) {
            // Print the message upon receiving any notification
            printf("Notified task received value: %lu\n", ulNotificationValue);
            printf("Ekaterina Breslavskaya 202212147\n");
        }
    }
}



2.36 xTaskNotifyAndQueryFromISR()
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h" // Include timers for software timer simulation
#include <stdio.h>

// Task Handle
TaskHandle_t taskHandle = NULL;

// Task Function Prototype
void TaskFunction(void* pvParameters);

// Timer callback function prototype
void TimerCallback(TimerHandle_t xTimer);

int main(void) {
    // Display the initial message
    printf("Ekaterina Breslavskaya 202212147. Task 2.36\n");

    // Create the task
    if (xTaskCreate(TaskFunction, "Task", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, &taskHandle) != pdPASS) {
        printf("Task creation failed!\n");
        return 1; // Return an error code if task creation failed
    }

    // Create a software timer that triggers the TimerCallback function
    TimerHandle_t timer = xTimerCreate("Timer", pdMS_TO_TICKS(1000), pdTRUE, (void*)0, TimerCallback);
    if (timer == NULL) {
        printf("Timer creation failed!\n");
        return 1; // Return an error code if timer creation failed
    }

    // Start the timer
    if (xTimerStart(timer, 0) != pdPASS) {
        printf("Failed to start the timer.\n");
        return 1; // Return an error code if timer start failed
    }

    // Start the scheduler
    vTaskStartScheduler();

    // If the scheduler starts, this line should never be reached
    printf("Failed to start the scheduler. Out of heap memory?\n");
    return 2; // Return an error code indicating scheduler start failure
}

// Task function that waits for notifications
void TaskFunction(void* pvParameters) {
    (void) pvParameters; // To prevent the 'unreferenced parameter' warning

    uint32_t ulNotificationValue;

    while (1) {
        // Wait indefinitely for a notification
        if (xTaskNotifyWait(0x00, 0xFFFFFFFF, &ulNotificationValue, portMAX_DELAY) == pdPASS) {
            // Print the message upon receiving a notification
            printf("Notification received: %lu\n", ulNotificationValue);
            printf("Ekaterina Breslavskaya 202212147. Task 2.36\n");
        }
    }
}

// Timer callback function simulating an ISR
void TimerCallback(TimerHandle_t xTimer) {
    BaseType_t xHigherPriorityTaskWoken = pdFALSE;
    uint32_t ulPreviousNotificationValue;

    // Notify the task from the simulated ISR and query the previous notification value
    xTaskNotifyAndQueryFromISR(taskHandle, 1, eSetBits, &ulPreviousNotificationValue, &xHigherPriorityTaskWoken);

    // Request a context switch if a higher priority task was woken
    portYIELD_FROM_ISR(xHigherPriorityTaskWoken);

    printf("ISR: Previous notification value was %lu\n", ulPreviousNotificationValue);
}





2.37 xTaskNotifyFromISR()
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h" // Include timers for software timer simulation
#include <stdio.h>

// Task Handle
TaskHandle_t taskHandle = NULL;

// Task Function Prototype
void TaskFunction(void* pvParameters);

// Timer callback function prototype
void TimerCallback(TimerHandle_t xTimer);

int main(void) {
    // Display the initial message
    printf("Ekaterina Breslavskaya 202212147. Task 2.37\n");

    // Create the task
    if (xTaskCreate(TaskFunction, "Task", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, &taskHandle) != pdPASS) {
        printf("Task creation failed!\n");
        return 1; // Return an error code if task creation failed
    }

    // Create a software timer that triggers the TimerCallback function
    TimerHandle_t timer = xTimerCreate("Timer", pdMS_TO_TICKS(1000), pdTRUE, (void*)0, TimerCallback);
    if (timer == NULL) {
        printf("Timer creation failed!\n");
        return 1; // Return an error code if timer creation failed
    }

    // Start the timer
    if (xTimerStart(timer, 0) != pdPASS) {
        printf("Failed to start the timer.\n");
        return 1; // Return an error code if timer start failed
    }

    // Start the scheduler
    vTaskStartScheduler();

    // If the scheduler starts, this line should never be reached
    printf("Failed to start the scheduler. Out of heap memory?\n");
    return 2; // Return an error code indicating scheduler start failure
}

// Task function that waits for notifications
void TaskFunction(void* pvParameters) {
    (void) pvParameters; // To prevent the 'unreferenced parameter' warning

    uint32_t ulNotificationValue;

    while (1) {
        // Wait indefinitely for a notification
        if (xTaskNotifyWait(0x00, 0xFFFFFFFF, &ulNotificationValue, portMAX_DELAY) == pdPASS) {
            // Print the message upon receiving a notification
            printf("Notification received: %lu\n", ulNotificationValue);
            printf("Ekaterina Breslavskaya 202212147. Task 2.37\n");
        }
    }
}

// Timer callback function simulating an ISR
void TimerCallback(TimerHandle_t xTimer) {
    BaseType_t xHigherPriorityTaskWoken = pdFALSE;

    // Notify the task from the simulated ISR
    xTaskNotifyFromISR(taskHandle, 0x01, eIncrement, &xHigherPriorityTaskWoken);

    // Request a context switch if a higher priority task was woken
    portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
}




2.38. xTaskNotifyGive()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task Handlers
TaskHandle_t notifierTaskHandle = NULL;
TaskHandle_t notifiedTaskHandle = NULL;

// Task Function Prototypes
void NotifierTask(void *pvParameters);
void NotifiedTask(void *pvParameters);

int main(void) {
    // Display initial message
    printf("Ekaterina Breslavskaya 202212147\n");

    // Create tasks
    xTaskCreate(NotifierTask, "NotifierTask", configMINIMAL_STACK_SIZE, NULL, 2, &notifierTaskHandle);
    xTaskCreate(NotifiedTask, "NotifiedTask", configMINIMAL_STACK_SIZE, NULL, 1, &notifiedTaskHandle);

    // Start the scheduler
    vTaskStartScheduler();

    // Infinite loop to prevent exiting `main`
    for (;;);
    return 0;
}

void NotifierTask(void *pvParameters) {
    while (1) {
        // Periodically give notification every second
        vTaskDelay(pdMS_TO_TICKS(1000));
        xTaskNotifyGive(notifiedTaskHandle);
        printf("Notifier: Notification given.\n");
    }
}

void NotifiedTask(void *pvParameters) {
    while (1) {
        // Wait indefinitely for a notification
        ulTaskNotifyTake(pdTRUE, portMAX_DELAY);
        printf("Notified: Notification received.\n");
        printf("Ekaterina Breslavskaya 202212147\n");
    }
}



2.39 xTaskNotifyGiveFromISR()
#include "FreeRTOS.h"
#include "task.h"
#include "timers.h" // Include timers for software timer simulation
#include <stdio.h>

// Task Handle
TaskHandle_t taskHandle = NULL;

// Task Function Prototype
void TaskFunction(void* pvParameters);

// Timer callback function prototype
void TimerCallback(TimerHandle_t xTimer);

// Main function
int main(void) {
    // Display the initial message
    printf("Ekaterina Breslavskaya 202212147. Task 2.39\n");

    // Create the task
    if (xTaskCreate(TaskFunction, "Task", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, &taskHandle) != pdPASS) {
        printf("Task creation failed!\n");
        return 1; // Return an error code if task creation failed
    }

    // Create a software timer that triggers the TimerCallback function
    TimerHandle_t timer = xTimerCreate("Timer", pdMS_TO_TICKS(1000), pdTRUE, (void*)0, TimerCallback);
    if (timer == NULL) {
        printf("Timer creation failed!\n");
        return 1; // Return an error code if timer creation failed
    }

    // Start the timer
    if (xTimerStart(timer, 0) != pdPASS) {
        printf("Failed to start the timer.\n");
        return 1; // Return an error code if timer start failed
    }

    // Start the scheduler
    vTaskStartScheduler();

    // If the scheduler starts, this line should never be reached
    printf("Failed to start the scheduler. Out of heap memory?\n");
    return 2; // Return an error code indicating scheduler start failure
}

// Task function that waits for notifications
void TaskFunction(void* pvParameters) {
    (void) pvParameters; // To prevent the 'unreferenced parameter' warning

    while (1) {
        // Wait indefinitely for a notification
        ulTaskNotifyTake(pdTRUE, portMAX_DELAY);

        // Print the message upon receiving a notification
        printf("Notification received\n");
        printf("Ekaterina Breslavskaya 202212147. Task 2.39\n");
    }
}

// Timer callback function simulating an ISR
void TimerCallback(TimerHandle_t xTimer) {
    BaseType_t xHigherPriorityTaskWoken = pdFALSE;

    // Notify the task from the simulated ISR
    vTaskNotifyGiveFromISR(taskHandle, &xHigherPriorityTaskWoken);

    // Request a context switch if a higher priority task was woken
    portYIELD_FROM_ISR(xHigherPriorityTaskWoken);
}





2.40 xTaskNotifyStateClear()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task Handlers
TaskHandle_t notifiedTaskHandle = NULL;

// Function Prototypes
void NotifiedTask(void *pvParameters);

int main(void) {
    // Display the initial message
    printf("Ekaterina Breslavskaya 202212147\n");

    // Create the task that will receive and clear notifications
    xTaskCreate(NotifiedTask, "NotifiedTask", configMINIMAL_STACK_SIZE, NULL, 1, &notifiedTaskHandle);

    // Start the scheduler
    vTaskStartScheduler();

    // Infinite loop to prevent exiting `main`
    for (;;);
    return 0;
}

void NotifiedTask(void *pvParameters) {
    uint32_t ulNotificationValue = 0;

    while (1) {
        // Wait indefinitely for a notification
        if (xTaskNotifyWait(0, ULONG_MAX, &ulNotificationValue, portMAX_DELAY) == pdPASS) {
            printf("Notification received: %lu\n", ulNotificationValue);
            printf("Ekaterina Breslavskaya 202212147\n");

            // Clear notification state after processing
            xTaskNotifyStateClear(NULL);
        }
    }
}

// Additional function to simulate notifying the task, could be placed in a timer or another task
void SimulateNotification(void) {
    const TickType_t xDelay = pdMS_TO_TICKS(5000);  // 5 seconds delay

    while (1) {
        vTaskDelay(xDelay);
        // Notify the task with a value incrementing each time
        xTaskNotify(notifiedTaskHandle, 1, eIncrement);
    }
}




2.55 taskYIELD()
#include "FreeRTOS.h"
#include "task.h"
#include <stdio.h>

// Task Function Prototypes
void Task1(void* pvParameters);
void Task2(void* pvParameters);

int main(void) {
    // Display the initial message
    printf("Starting FreeRTOS application\n");

    // Create two tasks
    xTaskCreate(Task1, "Task1", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
    xTaskCreate(Task2, "Task2", configMINIMAL_STACK_SIZE, NULL, 1, NULL);

    // Start the scheduler
    vTaskStartScheduler();

    // If the scheduler starts, this line should never be reached
    printf("Failed to start the scheduler. Out of heap memory?\n");
    return 1; // Return an error code indicating scheduler start failure
}

// Task1 function
void Task1(void* pvParameters) {
    (void) pvParameters; // To prevent the 'unreferenced parameter' warning

    while (1) {
        printf("Task1 is running. Yielding to Task2.\n");
        printf("Ekaterina Breslavskaya 202212147. Task 2.55\n");
        taskYIELD(); // Yield to Task2
    }
}

// Task2 function
void Task2(void* pvParameters) {
    (void) pvParameters; // To prevent the 'unreferenced parameter' warning

    while (1) {
        printf("Task2 is running. Yielding to Task1.\n");
        printf("Ekaterina Breslavskaya 202212147. Task 2.55\n");
        taskYIELD(); // Yield to Task1
    }
}





By Nyan Lin Maung Maung
2.46 xTaskResumeAll()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototypes
void vTask1(void* pvParameters);
void vTask2(void* pvParameters);
 
int main(void)
{
	// Create task 1
    xTaskCreate(vTask1, "Task1", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);
 
	// Create task 2
    xTaskCreate(vTask2, "Task2", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task 1 function
void vTask1(void* pvParameters)
{
	for (;;)
	{
        printf("Task 1 is running\n");
        vTaskDelay(pdMS_TO_TICKS(1000)); // Delay for 1 second
	}
}
 
// Task 2 function
void vTask2(void* pvParameters)
{
	// Suspend task 2 initially
    vTaskSuspend(NULL);
 
	for (;;)
	{
        printf("Task 2 is running\n");
        vTaskDelay(pdMS_TO_TICKS(1000)); // Delay for 1 second
	}
}



2.41 ulTaskNotifyTake()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
#include "semphr.h"
 
// Task function prototypes
void vTask1(void* pvParameters);
void vTask2(void* pvParameters);
 
// Semaphore handle
SemaphoreHandle_t xSemaphore;
 
int main(void)
{
	// Create a semaphore
    xSemaphore = xSemaphoreCreateBinary();
 
	// Create task 1
    xTaskCreate(vTask1, "Task1", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);
 
	// Create task 2
    xTaskCreate(vTask2, "Task2", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task 1 function
void vTask1(void* pvParameters)
{
	// Wait for the semaphore
	xSemaphoreTake(xSemaphore, portMAX_DELAY);
 
	// Task 1 continues here after acquiring the semaphore
    printf("Task 1 received notification from Task 2\n");
 
	// Task loop
	for (;;)
	{
        // Task does nothing but yield
        taskYIELD();
	}
}
 
// Task 2 function
void vTask2(void* pvParameters)
{
	// Task loop
	for (;;)
	{
        // Delay for 1 second
        vTaskDelay(pdMS_TO_TICKS(1000));
 
        // Give the semaphore to wake up task 1
        xSemaphoreGive(xSemaphore);
	}
}


 
2.42 xTaskNotifyWait()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototypes
void vTask1(void* pvParameters);
void vTask2(void* pvParameters);
 
// Task handles
TaskHandle_t xTask1Handle, xTask2Handle;
 
int main(void)
{
	// Create task 1
    xTaskCreate(vTask1, "Task1", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, &xTask1Handle);
 
	// Create task 2
    xTaskCreate(vTask2, "Task2", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, &xTask2Handle);
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task 1 function
void vTask1(void* pvParameters)
{
	// Wait for notification from task 2
    ulTaskNotifyTake(pdTRUE, portMAX_DELAY);
 
	// Task 1 continues here after receiving the notification
    printf("Task 1 received notification from Task 2\n");
 
	// Task loop
	for (;;)
	{
        // Task does nothing but yield
        taskYIELD();
	}
}
 
// Task 2 function
void vTask2(void* pvParameters)
{
	// Delay for 1 second
    vTaskDelay(pdMS_TO_TICKS(1000));
 
	// Send notification to task 1
	xTaskNotifyGive(xTask1Handle);
 
	// Task 2 continues here after sending the notification
    printf("Task 2 sent notification to Task 1\n");
 
	// Task loop
	for (;;)
	{
        // Task does nothing but yield
        taskYIELD();
	}
}


 
2.43 uxTaskPriorityGet()
#include <stdio.h>
#include <conio.h>
 
#include "FreeRTOS.h"
#include "FreeRTOSConfig.h"
#include "task.h"
#include "timers.h"
#include "queue.h"
#include "semphr.h"
 
void vTask1(void* pvParameters);
void vTask2(void* pvParameters);
 
int main(void)
{
	// Create Task 1
    xTaskCreate(vTask1,           	// Task function
        "Task1",         	// Task name
        configMINIMAL_STACK_SIZE,  // Stack size
        NULL,            	// Task parameters
        tskIDLE_PRIORITY + 1,  	// Priority
        NULL);           	// Task handle
 
	// Create Task 2
    xTaskCreate(vTask2,           	// Task function
        "Task2",         	// Task name
        configMINIMAL_STACK_SIZE,  // Stack size
        NULL,            	// Task parameters
        tskIDLE_PRIORITY + 2,  	// Priority
        NULL);           	// Task handle
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task 1 function
void vTask1(void* pvParameters)
{
	// Add a delay to ensure Task 1 gets CPU time
    vTaskDelay(pdMS_TO_TICKS(100));
 
	// Get the priority of Task 1
	UBaseType_t task1Priority = uxTaskPriorityGet(NULL);
 
	// Print the priority of Task 1
    printf("Task 1 priority: %u\n", task1Priority);
 
	// Task loop
	for (;;)
	{
        // Task 1 does nothing but yield
        taskYIELD();
	}
}
 
// Task 2 function
void vTask2(void* pvParameters)
{
	// Get the priority of Task 2
	UBaseType_t task2Priority = uxTaskPriorityGet(NULL);
 
	// Print the priority of Task 2
    printf("Task 2 priority: %u\n", task2Priority);
 
	// Task loop
	for (;;)
	{
        // Task 2 does nothing but yield
        taskYIELD();
	}
}


 
2.44 vTaskPrioritySet()
	#include <stdio.h>
	#include <conio.h>
 
	#include "FreeRTOS.h"
	#include "FreeRTOSConfig.h"
	#include "task.h"
	#include "timers.h"
	#include "queue.h"
	#include "semphr.h"
 
void vDynamicPriorityTask(void* pvParameters);
 
int main(void)
{
	// Create the dynamic priority task
    xTaskCreate(vDynamicPriorityTask,         // Task function
        "DynamicPriorityTask",    	// Task name
        configMINIMAL_STACK_SIZE,	// Stack size
        NULL,                    	// Task parameters
        tskIDLE_PRIORITY + 1,    	// Initial priority (can be changed later)
        NULL);                   	// Task handle
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task function that changes its priority after a delay
void vDynamicPriorityTask(void* pvParameters)
{
	// Task loop
	for (;;)
	{
        // Print current task priority
        printf("Current task priority: %d\n", uxTaskPriorityGet(NULL));
 
        // Delay for 2 seconds
        vTaskDelay(pdMS_TO_TICKS(2000));
 
        // Change task priority to a higher value
        vTaskPrioritySet(NULL, uxTaskPriorityGet(NULL) + 1);
 
        // Print new task priority
        printf("New task priority: %d\n", uxTaskPriorityGet(NULL));
 
        // Delay for 2 seconds
        vTaskDelay(pdMS_TO_TICKS(2000));
	}
}


2.45 vTaskResume()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototypes
void vSuspendedTask(void* pvParameters);
void vResumingTask(void* pvParameters);
 
int main(void)
{
	// Create the suspended task
    xTaskCreate(vSuspendedTask,         // Task function
        "SuspendedTask",    	// Task name
        configMINIMAL_STACK_SIZE,	// Stack size
        NULL,                    	// Task parameters
        tskIDLE_PRIORITY + 1,    	// Priority
        NULL);                   	// Task handle
 
	// Create the task that will resume the suspended task
    xTaskCreate(vResumingTask,         // Task function
        "ResumingTask",    	// Task name
        configMINIMAL_STACK_SIZE,	// Stack size
        NULL,                    	// Task parameters
        tskIDLE_PRIORITY + 2,    	// Priority
        NULL);                   	// Task handle
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task function that suspends itself
void vSuspendedTask(void* pvParameters)
{
	// Print a message indicating the task has started
    printf("SuspendedTask started\n");
 
	// Suspend the task for 5 seconds
    vTaskDelay(pdMS_TO_TICKS(5000));
 
	// Print a message indicating the task is being resumed
    printf("SuspendedTask is being resumed\n");
 
	// Resume itself
    vTaskResume(NULL);
 
	// Task loop
	for (;;)
	{
        // Task does nothing but yield
        taskYIELD();
	}
}
 
// Task function that does nothing
void vResumingTask(void* pvParameters)
{
	// Print a message indicating the task has started
    printf("ResumingTask started\n");
 
	// Task loop
	for (;;)
	{
        // Task does nothing but yield
        taskYIELD();
	}
}


2.47 xTaskResumeFromISR()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototype
void vSuspendedTask(void* pvParameters);
 
// Simulated interrupt handler
void vSimulatedISR(void);
 
// Task handle
TaskHandle_t xTaskToResume = NULL;
 
int main(void)
{
	// Create the suspended task
    xTaskCreate(vSuspendedTask,          // Task function
        "SuspendedTask",    	// Task name
        configMINIMAL_STACK_SIZE,  // Stack size
        NULL,                 	// Task parameters
        tskIDLE_PRIORITY + 1, 	// Priority
        &xTaskToResume);      	// Task handle
 
	// Simulate an interrupt to resume the suspended task
    vSimulatedISR();
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task function that prints a message
void vSuspendedTask(void* pvParameters)
{
	// Print a message indicating the task has started
    printf("SuspendedTask started\n");
 
	// Task loop
	for (;;)
	{
        // Task does nothing but yield
        taskYIELD();
	}
}
 
// Simulated interrupt handler that resumes a suspended task
void vSimulatedISR(void)
{
	// Resume the suspended task from the ISR
	BaseType_t xTaskResumed = xTaskResumeFromISR(xTaskToResume);
 
	if (xTaskResumed == pdTRUE)
	{
        printf("Task resumed from ISR\n");
	}
	else
	{
        printf("Failed to resume task from ISR\n");
	}
}
 
 
 
2.48 vTaskSetApplicationTaskTag()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototypes
void vTaggedTask(void* pvParameters);
 
int main(void)
{
	// Create the tagged task
    xTaskCreate(vTaggedTask,              // Task function
        "TaggedTask",         	// Task name
        configMINIMAL_STACK_SIZE,// Stack size
        NULL,                 	// Task parameters
        tskIDLE_PRIORITY + 1, 	// Priority
        NULL);                	// Task handle
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
void vTaggedTask(void* pvParameters)
{
    printf("Task is tagged!\n");
 
	// Task loop
	for (;;)
	{
       
        taskYIELD();
	}
}

 
 
2.49 vTaskSetThreadLocalStoragePointer()
#include <stdio.h>
#include <stdlib.h> // Include for rand() and srand()
#include <time.h>   // Include for seeding srand()
 
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototype
void vTaskWithTLS(void* pvParameters);
 
int main(void)
{
	// Seed the random number generator
    srand(time(NULL));
 
	// Create the task with thread-local storage (TLS)
    xTaskCreate(vTaskWithTLS,               // Task function
        "TaskWithTLS",         	// Task name
        configMINIMAL_STACK_SIZE,  // Stack size
        NULL,                  	// Task parameters
        tskIDLE_PRIORITY + 1,  	// Priority
        NULL);                 	// Task handle (not used in this example)
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task function that uses thread-local storage (TLS)
void vTaskWithTLS(void* pvParameters)
{
	// Define a thread-local storage variable and set it to a random number
	int tlsValue = rand() % 100; // Generates a random number between 0 and 99
 
	// Print the value of the thread-local storage variable
    printf("Thread-local storage value: %d\n", tlsValue);
 
	// Task loop
	for (;;)
	{
        // Task does nothing but yield
        taskYIELD();
	}
}


2.50 vTaskSetTimeOutState()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototypes
void vTask1(void* pvParameters);
void vTask2(void* pvParameters);
 
int main(void)
{
	// Create task 1
    xTaskCreate(vTask1, "Task1", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);
 
	// Create task 2
    xTaskCreate(vTask2, "Task2", configMINIMAL_STACK_SIZE, NULL, tskIDLE_PRIORITY + 1, NULL);
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task 1 function
void vTask1(void* pvParameters)
{
	const TickType_t xDelay = pdMS_TO_TICKS(1000); // 1000 milliseconds delay
 
	for (;;)
	{
        printf("Task 1 is running\n");
        vTaskDelay(xDelay); // Delay for 1000 milliseconds
	}
}
 
// Task 2 function
void vTask2(void* pvParameters)
{
	const TickType_t xDelay = pdMS_TO_TICKS(500); // 500 milliseconds delay
 
	for (;;)
	{
        printf("Task 2 is running\n");
        vTaskDelay(xDelay); // Delay for 500 milliseconds
	}
}


2.51  vTaskStartScheduler()
#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
 
// Task function prototype
void vTaskFunction(void* pvParameters);
 
int main(void)
{
	// Create a task
    xTaskCreate(vTaskFunction,         // Task function
        "Task",            	// Task name
        configMINIMAL_STACK_SIZE, // Stack size
        NULL,              	// Task parameters
        tskIDLE_PRIORITY + 1,  // Priority
        NULL);             	// Task handle (not used in this example)
 
	// Start the FreeRTOS scheduler
    vTaskStartScheduler();
 
	// This should never be reached
	for (;;);
 
	return 0;
}
 
// Task function
void vTaskFunction(void* pvParameters)
{
	// Task loop
	for (;;)
	{
        printf("Task is running\n");
 
        // Delay for 1 second
        vTaskDelay(pdMS_TO_TICKS(1000));
	}
}



