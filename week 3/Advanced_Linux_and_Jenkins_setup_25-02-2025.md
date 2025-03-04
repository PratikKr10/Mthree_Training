**📶 1. Networking Commands**

**1.1 Monitoring System Resources**

-   **top** -- Displays real-time information about system processes,
    CPU, and memory usage.

    -   top -u root -- Show processes for the root user.

    -   top -p \<PID\> -- Monitor a specific process by its Process ID
        (PID).

-   **ps** -- Displays information about running processes.

    -   ps aux \--sort=-%mem \| head -- Show top processes sorted by
        memory usage.

    -   ps -ef -- Full format listing of processes.

    -   ps -u pk -- Show processes owned by the user pk.

**1.2 Network Connectivity**

-   **ping** -- Tests connectivity to a host.

    -   ping google.com -- Sends continuous ping requests.

    -   ping -c 10 google.com -- Sends 10 packets and stops.

    -   ping -i 5 google.com -- Sends packets every 5 seconds.

    -   ping -s 32 google.com -- Sends packets of 32 bytes.

    -   ping -t 100 google.com -- Sets the time-to-live for packets.

**1.3 DNS Queries**

-   **nslookup** -- Queries DNS to resolve domain names.

    -   nslookup google.com -- Get the IP address of Google.

    -   nslookup -type=MX google.com -- Fetch mail exchange records.

    -   nslookup -type=A google.com -- Get the IP address.

    -   nslookup -type=TXT google.com -- Fetch TXT records.

    -   nslookup -query=ANY google.com -- Retrieve all DNS records.

**1.4 Network Configuration**

-   **ifconfig** -- Displays network interfaces and configurations.

    -   ifconfig -- Show active network interfaces.

    -   ifconfig -a -- Show all interfaces, including inactive ones.

    -   sudo ifconfig eth0 up -- Enable the eth0 interface.

**1.5 File Transfers & HTTP Requests**

-   **curl** -- Transfers data from URLs.

    -   curl http://google.com -- Fetch the webpage content.

    -   curl -o google.txt http://google.com -- Save the output to a
        file.

    -   curl -I http://google.com -- Get only the headers.

    -   curl -L http://google.com -- Follow redirects.

    -   curl -v http://google.com -- Show verbose output.

**1.6 Network Monitoring**

-   **tcpdump** -- Captures network traffic.

    -   sudo tcpdump -i any -- Capture packets on all interfaces.

    -   sudo tcpdump -i any -c 10 -- Capture 10 packets and stop.

-   **iperf** -- Tests network bandwidth.

    -   iperf -s -- Start Iperf in server mode.

    -   iperf -s -f M -- Display results in Megabytes per second (MB/s).

**👤 2. User Management Commands**

**2.1 User and Group Management**

-   **Add Users:**

    -   sudo adduser pktry -- Create a user pktry with a home directory.

    -   sudo useradd -m pktry -- Alternative command for adding a user.

    -   sudo passwd pktry -- Set password for the user pktry.

-   **Switch Users:**

    -   sudo su - pktry -- Switch to pktry user with the environment
        loaded.

    -   su - pk -- Switch to pk user.

-   **Delete Users:**

    -   sudo userdel -r pk -- Remove the user pk and their home
        directory.

    -   sudo userdel -rf pk -- Force delete the user and their files.

-   **Manage Groups:**

    -   sudo groupadd c406cohort -- Create a group c406cohort.

    -   sudo usermod -aG c406cohort pktry -- Add pktry to the group.

    -   cat /etc/group \| grep c406cohort -- Verify group membership.

**2.2 File and Directory Permissions**

-   **Change Permissions:**

    -   sudo chmod 755 /home/pktry -- Set read, write, and execute for
        owner, and read-execute for others.

    -   sudo chmod g+s /home/grouptry/pratik/a -- Set the SGID bit for
        group ownership inheritance.

-   **Ownership:**

    -   sudo chown pktry:c406cohort /home/grouptry -- Change ownership
        of a directory.

**2.3 System Information and Monitoring**

-   **Memory Usage:**

    -   free -h -- Show memory usage in human-readable format.

    -   free -m -- Display memory in MB.

    -   free -g -- Display memory in GB.

    -   free -t -- Show total memory (RAM + Swap).

    -   free -s 5 -- Refresh memory stats every 5 seconds.

-   **Disk Space:**

    -   df -h -- Display disk space usage in human-readable format.

-   **File Details:**

    -   ls -lrt -- List files sorted by modification time.

    -   stat google.txt -- Show detailed information about the file.

    -   cat google.txt -- Display file contents.

**⚙️ 3. Jenkins Setup Commands**

**3.1 Install Java (Required for Jenkins)**

sudo apt update

sudo apt install fontconfig openjdk-17-jre -y

java -version

**3.2 Add Jenkins Repository & Install Jenkins**

1.  **Add Jenkins Key and Repository:**

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key \|
sudo tee /usr/share/keyrings/jenkins-keyring.asc \> /dev/null

echo \"deb \[signed-by=/usr/share/keyrings/jenkins-keyring.asc\]
https://pkg.jenkins.io/debian-stable binary/\" \| sudo tee
/etc/apt/sources.list.d/jenkins.list \> /dev/null

2.  **Install Jenkins:**

sudo apt update

sudo apt install jenkins -y

**3.3 Manage Jenkins Service**

-   **Start Jenkins:**

sudo systemctl start jenkins

-   **Enable Jenkins at Boot:**

sudo systemctl enable jenkins

-   **Check Jenkins Status:**

sudo systemctl status jenkins

**3.4 Access Jenkins**

1.  Open browser:

http://localhost:8080

2.  Retrieve Initial Admin Password:

sudo cat /var/lib/jenkins/secrets/initialAdminPassword

**3.5 Troubleshooting Jenkins**

-   **Check Logs:**

sudo cat /var/log/jenkins/jenkins.log \| grep -i \"error\"

-   **Restart Jenkins:**

sudo systemctl restart jenkins

Here\'s the updated Word document content, including the SSH key setup
for GitHub.

**🔑 4. SSH Key Setup for GitHub**

**4.1 Generate SSH Key Pair**

Create an SSH key pair for secure GitHub access:

ssh-keygen -t rsa -b 4096 -C \"pratik010kumar@gmail.com\"

-   **-t rsa**: Specifies the RSA key type.

-   **-b 4096**: Sets key length to 4096 bits (strong encryption).

-   **-C**: Adds a label (usually your email) for identification.

**4.2 Add SSH Key to SSH Agent**

Start the SSH agent and add your private key:

eval \"\$(ssh-agent -s)\"

ssh-add \~/.ssh/id_rsa

**4.3 Add SSH Key to GitHub**

1.  Copy the public key:

cat \~/.ssh/id_rsa.pub

2.  Go to **GitHub → Settings → SSH and GPG keys**.

3.  Click **New SSH Key**, paste the key, and save.

**4.4 Verify GitHub Connection**

Test the SSH connection:

ssh -T git@github.com

Expected output:

Hi PratikKr10! You\'ve successfully authenticated, but GitHub does not
provide shell access.
