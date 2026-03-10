# P3 – BGP EVPN (42 VM)

## Part A – Work in the VM

### 1. Clone and open project

```bash
git clone <repo_url>
cd BADASS-chchao
```

### 2. Build P3 Docker images (from SetupImages)

```bash
cd P3/SetupImages
for d in rr_lgirault_1 router_chchao_1 router_lgirault_2 router_thrio_3 host_chchao_1 host_lgirault_2 host_thrio_3; do
  (cd "$d" && docker build -t "p3-$d" .)
done
```

Or build one by one, e.g.:

```bash
cd P3/SetupImages/router_chchao_1 && docker build -t p3-router_chchao_1 .
```

### 3. Start GNS3

- Open GNS3 in the VM.
- **Import project 3:** File → Import portable project → choose `P3/P3.gns3project` (or your exported ZIP). Include base images when asked.
- **Run the imported machines:** Start all nodes (RR, VTEPs, hosts) from the topology.
- **Configure the machines:** Each node uses the config baked into its image (from `P3/config/` or the same content in `SetupImages/`). No manual paste needed if you built from SetupImages; otherwise paste the right `frr.conf` or script per node.

---

## Part B – Step-by-step test (evaluation checklist)

A person from the group should show the following with short explanations.

### 1. Configuration files for this part

- Point to **P3/config/** (and/or **P3/SetupImages/**):
  - RR: `rr_lgirault_1/frr.conf`, `init_rr.sh`
  - VTEPs: `router_chchao_1/`, `router_lgirault_2/`, `router_thrio_3/` (each: `frr.conf`, `init_router_*.sh`)
  - Hosts: `host_chchao_1/`, `host_lgirault_2/`, `host_thrio_3/` (each: `add_Ip_Host*.sh` or `add_ip_host1.sh`)

### 2. Import project 3 into GNS3

- In GNS3: File → Import portable project.
- Select `P3/P3.gns3project` (or the exported P3 ZIP).
- Choose to include base images so the project runs on the evaluator’s VM.

### 3. Run the imported machines in GNS3

- Start the RR, then the three VTEPs, then the host nodes.
- Ensure links match the subject topology (RR ↔ VTEPs, each VTEP ↔ its host(s)).

### 4. Configure all machines in the subject topology

- If using pre-built images from SetupImages: config is already in the image; interfaces and FRR start via the init scripts.
- Otherwise: paste the matching `frr.conf` into each router/VTEP console and run the init script; on hosts run the host script (e.g. `add_ip_host1.sh` or `add_Ip_Host1.sh`).

### 5. Disable all HOST machines in GNS3

- In GNS3, stop or “power off” every host node (host_chchao_1, host_lgirault_2, host_thrio_3).
- Only RR and VTEPs remain running.

### 6. No type 2 routes – only type 3

- On the RR or any VTEP:  
  `vtysh -c "show bgp l2vpn evpn route-type 2"`  
  → should be empty or no type 2.
- Then:  
  `vtysh -c "show bgp l2vpn evpn route-type 3"`  
  → only type 3 routes (e.g. inclusive multicast for VNI 10). **VNI must be 10.**

### 7. Learning on VTEPs – one host, no IP, type 2 appears

- **Enable a single host** (e.g. host_chchao_1).
- **Do not configure any IP** on that host (only bring the interface up, as in `add_ip_host1.sh` without the `ip addr add` line).
- On a VTEP (e.g. router_chchao_1):  
  `vtysh -c "show bgp l2vpn evpn route-type 2"`  
  → a type 2 route (MAC/IP) for that host must appear. Explain that the VTEP learned the host’s MAC via EVPN.

### 8. Enable all hosts and configure IPs

- Start the other host nodes.
- On each host, configure an IP (e.g. uncomment or run the `ip addr add` line in the host script, or run manually), e.g.:
  - host_chchao_1: `20.1.1.10/24`
  - host_lgirault_2: `20.1.1.20/24`
  - host_thrio_3: `20.1.1.30/24`

### 9. Ping and packet inspection

- From one host, ping another: e.g. `ping 20.1.1.20` or `ping 20.1.1.30`.
- **Packet inspection:** Capture on a link (e.g. RR–VTEP or VTEP–host) and show:
  - VXLAN (VNI 10) and inner Ethernet/IP as in the subject example.
  - **OSPF packets** visible on the underlay (RR–VTEP links).

### 10. Checklist summary

- [ ] Configuration files shown (P3/config and/or SetupImages).
- [ ] Project 3 imported into GNS3.
- [ ] All machines run and are configured per topology.
- [ ] All hosts disabled → only type 3 routes.
- [ ] One host enabled with no IP → type 2 route visible on VTEP.
- [ ] All hosts enabled, IPs configured, ping works.
- [ ] Packet capture shows VNI 10 and OSPF on the underlay.
