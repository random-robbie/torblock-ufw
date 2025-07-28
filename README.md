# torblock-ufw

`torblock-ufw` is a simple shell script that enhances your system's security by automatically blocking traffic from known Tor exit nodes using UFW (Uncomplicated Firewall).

## How it Works

This script performs the following actions:

1.  **Downloads Tor Exit Node List:** Fetches an updated list of Tor exit nodes from a reliable source (`https://www.dan.me.uk/torlist/`).
2.  **Compares and Updates:**
    *   If a previous list exists, it identifies new Tor IPs to block and old Tor IPs that are no longer active (and thus should be unblocked).
    *   If no previous list exists, it blocks all IPs from the downloaded list.
3.  **Applies UFW Rules:** Adds `ufw deny` rules for new Tor exit nodes and removes rules for IPs no longer on the list.
4.  **Initial Setup (First Run):** On its first execution, it also allows 'Nginx full' and 'ssh' through UFW, assuming these are common services you might want to keep accessible.

## Prerequisites

Before running this script, ensure you have the following installed:

*   **UFW (Uncomplicated Firewall):** This script relies on UFW to manage firewall rules. Most Debian/Ubuntu-based systems have it pre-installed or it can be installed via `sudo apt install ufw`.
*   **`wget`:** Used to download the Tor exit node list. Install with `sudo apt install wget` if you don't have it.

## Usage

### 1. Manual Execution

You can run the script directly from your terminal. This is useful for a one-time update or testing.

```bash
# Make the script executable (if you downloaded it manually)
# chmod +x torblock.sh

# Run the script
# ./torblock.sh

# Or, for a quick run (use with caution, always review scripts before piping to bash)
curl -L https://raw.githubusercontent.com/random-robbie/torblock-ufw/master/torblock.sh | bash
```

**Note:** Piping scripts directly from the internet to `bash` can be a security risk. It's always recommended to review the script's content before executing it.

### 2. Automating with Cron (Recommended for Regular Updates)

To keep your Tor block list updated automatically, you can set up a cron job. This will run the script at specified intervals (e.g., daily).

1.  **Download the script:**
    ```bash
    wget https://raw.githubusercontent.com/random-robbie/torblock-ufw/master/torblock.sh -O /usr/local/bin/torblock.sh
    ```
2.  **Make it executable:**
    ```bash
    chmod +x /usr/local/bin/torblock.sh
    ```
3.  **Edit your crontab:**
    ```bash
    crontab -e
    ```
4.  **Add the following line to the crontab file** (this example runs the script daily at 3:00 AM):
    ```cron
    0 3 * * * /usr/local/bin/torblock.sh > /dev/null 2>&1
    ```
    You can adjust `0 3 * * *` to your preferred schedule. For example, `0 */6 * * *` would run it every 6 hours.

## Security Considerations

*   **Not a complete solution:** Blocking Tor exit nodes is an additional layer of security, but it's not a foolproof method to prevent all malicious activity. It primarily aims to reduce unwanted connections originating from the Tor network.
*   **False Positives:** Occasionally, legitimate traffic might originate from a Tor exit node. This script might block such traffic. If you experience issues with certain services, you may need to temporarily disable the block or investigate the source IP.
*   **Review and Understand:** Always review the script's code before running it on your system to understand its functionality and ensure it meets your security requirements.

## Disclaimer

This script is provided as-is, without any warranty. Use it at your own risk. The author is not responsible for any damages or issues that may arise from its use. Always back up your system and understand the implications of firewall rule changes.

## Cloud Credits for Security Testing

Perfect for setting up security labs and testing environments:

**DigitalOcean** - Get $200 credit for 60 days when you sign up and add a payment method  
[![DigitalOcean Referral Badge](https://web-platforms.sfo2.cdn.digitaloceanspaces.com/WWW/Badge%203.svg)](https://www.digitalocean.com/?refcode=e22bbff5f6f1&utm_campaign=Referral_Invite&utm_medium=Referral_Program&utm_source=badge)

**Linode** - Great for security lab setups and testing infrastructure  
[![Linode Referral Badge](https://github.com/pry0cc/axiom/blob/3e8dca3d58a02dc71778492a1fe077e769f93edd/screenshots/Referrals/Linode-referral.png)](https://www.linode.com/lp/refer/?r=f359e3680225dbea12417cec5cb672686febc053)