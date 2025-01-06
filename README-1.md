# sample-laravel-app
Here is a **step-by-step guide** to set up a Laravel project on an **Ubuntu EC2 instance**, including the configuration, basic Laravel application pages, and commands to execute.

---

### **Step 1: Launch an Ubuntu EC2 Instance**

1. **Create the Instance:**
   - Log in to AWS Management Console.
   - Navigate to **EC2** > **Launch Instance**.
   - Select **Ubuntu 20.04 LTS** as the AMI.
   - Choose an instance type (`t2.micro` for free tier).
   - Configure **security groups**:
     - Allow **22 (SSH)**, **80 (HTTP)**, and optionally **443 (HTTPS)**.

2. **Connect to the Instance:**
   - Use the private key (`.pem`) to SSH into the instance:
     ```bash
     ssh -i "your-key.pem" ubuntu@<your-ec2-public-ip>
     ```

---

### **Step 2: Update and Install Required Packages**

1. **Update System Packages:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Install PHP and Required Extensions:**
   ```bash
   sudo apt install php-cli php-fpm php-mysql php-mbstring php-xml php-bcmath php-curl unzip git -y
   ```

3. **Install Composer:**
   ```bash
   curl -sS https://getcomposer.org/installer | php
   sudo mv composer.phar /usr/local/bin/composer
   ```

4. **Install MySQL (Optional):**
   ```bash
   sudo apt install mysql-server -y
   sudo mysql_secure_installation
   ```

5. **Install Nginx:**
   ```bash
   sudo apt install nginx -y
   ```

---

### **Step 3: Set Up Laravel Project**

1. **Download Laravel:**
   ```bash
   composer create-project --prefer-dist laravel/laravel laravel-app
   ```

2. **Move Project to Web Directory:**
   ```bash
   sudo mv laravel-app /var/www/laravel-app
   ```

3. **Set Permissions:**
   ```bash
   sudo chown -R www-data:www-data /var/www/laravel-app
   sudo chmod -R 775 /var/www/laravel-app/storage /var/www/laravel-app/bootstrap/cache
   ```

4. **Set Up the `.env` File:**
   ```bash
   cd /var/www/laravel-app
   cp .env.example .env
   php artisan key:generate
   ```

   Update `.env` for database connection if needed:
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=laravel
   DB_USERNAME=root
   DB_PASSWORD=your_mysql_password
   ```

   If using MySQL, create a database:
   ```bash
   sudo mysql -u root -p
   CREATE DATABASE laravel;
   EXIT;
   ```

5. **Run Laravel Migrations:**
   ```bash
   php artisan migrate
   ```

---

### **Step 4: Configure Nginx**

1. **Create Nginx Configuration for Laravel:**
   ```bash
   sudo nano /etc/nginx/sites-available/laravel
   ```

   Add the following configuration:
   ```nginx
   server {
       listen 80;
       server_name your-ec2-public-ip;

       root /var/www/laravel-app/public;

       index index.php index.html;

       location / {
           try_files $uri $uri/ /index.php?$query_string;
       }

       location ~ \.php$ {
           include snippets/fastcgi-php.conf;
           fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
           fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
           include fastcgi_params;
       }

       location ~ /\.ht {
           deny all;
       }
   }
   ```

2. **Enable the Site and Restart Nginx:**
   ```bash
   sudo ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

3. **Test the Setup:**
   Visit `http://<your-ec2-public-ip>` in a browser.

---

### **Step 5: Add Basic Laravel Pages**

1. **Add Routes:**
   Edit `routes/web.php`:
   ```php
   Route::get('/login', function () {
       return view('login');
   });

   Route::get('/dashboard', function () {
       return view('dashboard');
   });
   ```

2. **Create Views:**

   **Login Page (`resources/views/login.blade.php`):**
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>Login</title>
   </head>
   <body>
       <h1>Login Page</h1>
       <form>
           <label>Email:</label>
           <input type="email" name="email" required>
           <br>
           <label>Password:</label>
           <input type="password" name="password" required>
           <br>
           <button type="submit">Login</button>
       </form>
   </body>
   </html>
   ```

   **Dashboard Page (`resources/views/dashboard.blade.php`):**
   ```html
   <!DOCTYPE html>
   <html>
   <head>
       <title>Dashboard</title>
   </head>
   <body>
       <h1>Welcome to the MNK Dashboard</h1>
   </body>
   </html>
   ```

3. **Test Routes:**
   Visit:
   - `http://<your-ec2-public-ip>/login`
   - `http://<your-ec2-public-ip>/dashboard`

---

### **Step 6: Enable HTTPS (Optional)**

1. **Install Certbot:**
   ```bash
   sudo apt install certbot python3-certbot-nginx -y
   ```

2. **Get an SSL Certificate:**
   ```bash
   sudo certbot --nginx -d your-domain-name
   ```

3. **Test HTTPS:**
   Visit `https://your-domain-name`.

---

### **Step 7: Monitor and Maintain**

1. **Check Logs:**
   - Laravel logs: `/var/www/laravel-app/storage/logs/`
   - Nginx logs: `/var/log/nginx/`

2. **Restart Services if Needed:**
   ```bash
   sudo systemctl restart php8.1-fpm
   sudo systemctl restart nginx
   ```

---

### **Conclusion**

You now have a Laravel application running on an Ubuntu EC2 instance with basic routes (`/login` and `/dashboard`).

The Screenshots is available in mnk-laravel/images folder 

