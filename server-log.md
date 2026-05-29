# 1. Combien de lignes contient server.log ?

```bash
wc -l ressources/server.log
```

```
22
```

# 2. Affichez uniquement les 5 premières lignes

```bash
head -n 5 ressources/server.log
```

```
2024-01-15 08:00:01 INFO  Application started on port 8080
2024-01-15 08:00:05 INFO  Connected to Azure SQL Database successfully
2024-01-15 08:01:22 WARNING High memory usage detected: 78%
2024-01-15 08:02:45 ERROR Failed to connect to Azure Storage: connection timeout
2024-01-15 08:03:10 INFO  Request processed: GET /api/health [200]
```

# 3. Affichez uniquement les 3 dernières lignes

```bash
tail -n 3 ressources/server.log
```

```
2024-01-15 08:19:30 CRITICAL Azure Key Vault unreachable — secrets cannot be retrieved
2024-01-15 08:20:00 INFO  Health check passed: all 3 replicas running
2024-01-15 08:21:00 CRITICAL Disk full on /var/log — logging suspended
```

# 4. Combien de lignes contiennent le mot ERROR ?

```bash
grep -c "ERROR" ressources/server.log
```

```
5
```

# 5. Affichez toutes les lignes WARNING

```bash
grep "WARNING" ressources/server.log
```

```
2024-01-15 08:01:22 WARNING High memory usage detected: 78%
2024-01-15 08:06:15 WARNING CPU usage spike detected: 92%
2024-01-15 08:10:15 WARNING Disk space below threshold: 15% remaining on /dev/sda1
2024-01-15 08:16:30 WARNING SSL certificate expires in 14 days for api.azuretech.fr
```

# 6. Affichez toutes les lignes CRITICAL

```bash
grep "CRITICAL" ressources/server.log
```

```
2024-01-15 08:18:00 CRITICAL Database connection pool exhausted — all 20 connections in use
2024-01-15 08:19:30 CRITICAL Azure Key Vault unreachable — secrets cannot be retrieved
2024-01-15 08:21:00 CRITICAL Disk full on /var/log — logging suspended
```

# 7. Combien d'erreurs ET de critiques y a-t-il au total ?

```bash
grep -c "ERROR" ressources/server.log && grep -c "CRITICAL" ressources/server.log
```

```
5
3
```
