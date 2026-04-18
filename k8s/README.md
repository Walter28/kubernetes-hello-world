

**Configuration Kubernetes complète ajoutée!**

## **Nouveaux fichiers de configuration:**

### **Sécurité et Isolation**
- **namespace.yaml** - Namespace dédié `hello-world`
- **networkpolicy.yaml** - Politiques de réseau restrictives
- **limitrange.yaml** - Limites de ressources par défaut
- **resourcequota.yaml** - Quotas de ressources du namespace

### **Configuration et Secrets**
- **configmap.yaml** - Variables d'environnement
- **secret.yaml** - Secrets encodés base64

### **Haute Disponibilité**
- **hpa.yaml** - Auto-scaling horizontal (2-10 replicas)
- **poddisruptionbudget.yaml** - Garantie de disponibilité

### **Déploiements mis à jour**
- **backend/frontend deployments** - Namespace + ConfigMap + Secrets
- **services** - Namespace ajouté
- **ingress** - Namespace ajouté

### **Gestion avec Kustomize**
- **kustomization.yaml** - Déploiement unifié avec toutes les ressources

## **Pour déployer:**

### **Avec Kustomize (recommandé):**
```bash
kubectl apply -k k8s/
```

### **Déploiement manuel:**
```bash
kubectl apply -f k8s/
```

### **Vérification:**
```bash
kubectl get all -n hello-world
kubectl get hpa -n hello-world
kubectl get networkpolicy -n hello-world
```

L'application est maintenant production-ready avec sécurité, auto-scaling et haute disponibilité!