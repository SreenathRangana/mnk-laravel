Below are the YAML manifests for deploying Laravel with Nginx and a MySQL database in Kubernetes. These configurations include the use of **ConfigMaps** and **Secrets** for injecting environment variables and a **LoadBalancer** service to expose the application.

---

### **1. ConfigMap for Laravel Application**
Use a ConfigMap to store application environment variables.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: laravel-config
  namespace: laravel
data:
  APP_ENV: production
  APP_KEY: base64:YourAppKeyHere
  APP_DEBUG: "false"
  APP_URL: http://your-app-url.com
  DB_CONNECTION: mysql
  DB_HOST: mysql
  DB_PORT: "3306"
  DB_DATABASE: laravel
  DB_USERNAME: laravel_user
```

---

### **2. Secret for Sensitive Data**
Use a Secret to store sensitive credentials, such as database passwords.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: laravel-secrets
  namespace: laravel
type: Opaque
data:
  DB_PASSWORD: bGFyYXZlbF9wYXNzd29yZA== # Base64-encoded value for "laravel_password"
```

To encode values in base64:
```bash
echo -n "laravel_password" | base64
```

---

### **3. Deployment for Nginx + Laravel**
This Deployment runs both Nginx and Laravel in a single pod.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: laravel-app
  namespace: laravel
spec:
  replicas: 2
  selector:
    matchLabels:
      app: laravel
  template:
    metadata:
      labels:
        app: laravel
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
        volumeMounts:
        - name: app-code
          mountPath: /var/www/laravel-app
        - name: nginx-config
          mountPath: /etc/nginx/conf.d/default.conf
          subPath: default.conf
      - name: php-fpm
        image: php:8.1-fpm
        workingDir: /var/www/laravel-app
        ports:
        - containerPort: 9000
        envFrom:
        - configMapRef:
            name: laravel-config
        - secretRef:
            name: laravel-secrets
        volumeMounts:
        - name: app-code
          mountPath: /var/www/laravel-app
        command: ["/bin/sh"]
        args: ["-c", "php artisan serve --host=0.0.0.0 --port=9000"]
      volumes:
      - name: app-code
        persistentVolumeClaim:
          claimName: laravel-pvc
      - name: nginx-config
        configMap:
          name: nginx-config
```

---

### **4. Deployment for MySQL Database**
If you're using AWS RDS, skip this and configure the RDS database instead.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
  namespace: laravel
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: mysql:8.0
        env:
        - name: MYSQL_DATABASE
          valueFrom:
            configMapKeyRef:
              name: laravel-config
              key: DB_DATABASE
        - name: MYSQL_USER
          valueFrom:
            configMapKeyRef:
              name: laravel-config
              key: DB_USERNAME
        - name: MYSQL_PASSWORD
          valueFrom:
            secretKeyRef:
              name: laravel-secrets
              key: DB_PASSWORD
        - name: MYSQL_ROOT_PASSWORD
          value: root_password
        ports:
        - containerPort: 3306
        volumeMounts:
        - name: mysql-data
          mountPath: /var/lib/mysql
      volumes:
      - name: mysql-data
        emptyDir: {}
```

---

### **5. Persistent Volume Claim**
Define a PersistentVolumeClaim (PVC) for Laravel application storage.

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: laravel-pvc
  namespace: laravel
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

---

### **6. Service for Nginx + Laravel**
Expose Laravel via a LoadBalancer service.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: laravel-service
  namespace: laravel
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 80
  selector:
    app: laravel
```

---

### **7. Service for MySQL**
Expose MySQL internally to Laravel.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
  namespace: laravel
spec:
  ports:
  - port: 3306
    targetPort: 3306
  selector:
    app: mysql
```

---

### **8. Namespace**
Deploy all resources under a dedicated namespace.

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: laravel
```

---

### **Applying the Configuration**
1. Create the namespace:
   ```bash
   kubectl apply -f namespace.yaml
   ```

2. Apply the ConfigMap and Secret:
   ```bash
   kubectl apply -f configmap.yaml
   kubectl apply -f secret.yaml
   ```

3. Deploy Laravel and MySQL:
   ```bash
   kubectl apply -f laravel-deployment.yaml
   kubectl apply -f mysql-deployment.yaml
   ```

4. Deploy Services:
   ```bash
   kubectl apply -f laravel-service.yaml
   kubectl apply -f mysql-service.yaml
   ```

---

### **Important Notes**
1. **Using AWS RDS:**
   If you're using AWS RDS, replace the `DB_HOST` value in the `ConfigMap` with the RDS endpoint.

2. **Ingress Configuration:**
   You can optionally configure an Ingress resource instead of a LoadBalancer service for better routing and domain management.

3. **Persistent Storage:**
   Ensure you have a suitable storage class in your Kubernetes cluster for persistent volume claims.