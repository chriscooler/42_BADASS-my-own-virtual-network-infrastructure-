## What each SetupImages folder does

**SetupImages is the only source for P3:** every node (RR, VTEPs, hosts) is built from one subfolder. Each folder has its Dockerfile + scripts/config needed to build and run that node.

| Folder | Role in P3 | Contents | What the image does when run |
|--------|------------|----------|------------------------------|
| **rr_lgirault_1** | Route Reflector (RR) | Dockerfile, frr.conf, init_rr.sh | Brings up eth0/eth1/eth2/lo, starts FRR. BGP EVPN RR + OSPF underlay. |
| **router_chchao_1** | VTEP 1 (your login) | Dockerfile, frr.conf, init_router_chchao_1.sh | Brings up interfaces, creates br0 + vxlan10 (VNI 10), starts FRR. BGP EVPN leaf toward RR. |
| **router_lgirault_2** | VTEP 2 | Dockerfile, frr.conf, init_router_lgirault_2.sh | Same as above: br0, vxlan10 (VNI 10), FRR BGP EVPN leaf. |
| **router_thrio_3** | VTEP 3 | Dockerfile, frr.conf, init_router_thrio_3.sh | Same: br0, vxlan10 (VNI 10), FRR BGP EVPN leaf. |
| **host_chchao_1** | Host behind VTEP 1 | Dockerfile, add_ip_host1.sh | Brings eth1 up; optional IP for ping (see script comments). |
| **host_lgirault_2** | Host behind VTEP 2 | Dockerfile, add_Ip_Host2.sh | Brings eth0 up; optional IP for ping. |
| **host_thrio_3** | Host behind VTEP 3 | Dockerfile, add_Ip_Host3.sh | Brings eth0 up; optional IP for ping. |

Each folder is self-contained: `docker build` in that folder produces one image. Use that image in GNS3 for the matching node (RR, VTEP, or host).

---

## How to use the flat files (_chchao-1, _chchao-1_host, …)

The flat files under `P3/` are the **subject layout** and your **paste source** when you configure by hand (e.g. generic FRR/host image in GNS3, no pre-built P3 image).

- **Router/VTEP nodes:** Open `_chchao-1`, `_chchao-2`, `_chchao-3`, `_chchao-4`. Each file has:
  - A block of **Linux commands** (br0, vxlan10, brctl) — run these in the node’s shell first if it’s a VTEP.
  - A block of **FRR config** (hostname, interface, router bgp, router ospf) — run `vtysh` then `conf t`, then paste that block.
- **Host nodes:** Open `_chchao-1_host`, `_chchao-2_host`, `_chchao-3_host`. Run the shell commands in the host’s console (bring interface up; optionally add IP for ping).

**Mapping:** `_chchao-1` = RR (frrr-1), `_chchao-2` = VTEP1 (frrr-2), `_chchao-3` = VTEP2 (frrr-3), `_chchao-4` = VTEP3 (frrr-4). Hosts: `_chchao-1_host` = host behind VTEP1 (alpine-1), etc.

---

## Part A 
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

Or how to run each image on its own, e.g.:
```bash
cd P3/SetupImages/router_chchao_1 && docker build -t p3-router_chchao_1 . && docker run -it --rm p3-router_chchao_1
```


### 3. Start GNS3

- Open GNS3 in the VM.
- **Import project 3:** File → Import portable project → choose `P3/P3.gns3project` (or your exported ZIP). Include base images when asked.
- **Run the imported machines:** Start all nodes (RR, VTEPs, hosts) from the topology.
- **Configure the machines:** Each node uses the config baked into its image (from `P3/SetupImages/`). No manual paste needed if you built from SetupImages.

---

## Part B – Step-by-step test

### 1. Configuration files for this part

- Point to **P3/SetupImages/**
  - RR: `SetupImages/rr_lgirault_1/` (frr.conf, init_rr.sh)
  - VTEPs: `router_chchao_1/`, `router_lgirault_2/`, `router_thrio_3/` (each: frr.conf, init_router_*.sh)
  - Hosts: `host_chchao_1/`, `host_lgirault_2/`, `host_thrio_3/` (each: add_Ip_Host*.sh or add_ip_host1.sh)

### 2. Import project 3 into GNS3

- In GNS3: File → Import portable project.
- Select `P3/P3.gns3project` (or the exported P3 ZIP).
- Choose to include base images so the project runs on the evaluator’s VM.

### 3. Run the imported machines in GNS3

- Start the RR, then the three VTEPs, then the host nodes.
- Ensure links match the subject topology (RR ↔ VTEPs, each VTEP ↔ its host(s)).

### 4. Configure all machines in the subject topology

- Config is in the image when you build from SetupImages; interfaces and FRR start via the init scripts. No extra paste needed.

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

- [ ] Configuration files shown (P3/SetupImages and flat files _chchao-*).
- [ ] Project 3 imported into GNS3.
- [ ] All machines run and are configured per topology.
- [ ] All hosts disabled → only type 3 routes.
- [ ] One host enabled with no IP → type 2 route visible on VTEP.
- [ ] All hosts enabled, IPs configured, ping works.
- [ ] Packet capture shows VNI 10 and OSPF on the underlay.

---

## Part C – Step-by-step test order (your runbook)

Order to configure and verify P3. Use flat files `_chchao-*` as reference; paste from them into each node’s console.

### 1. RR (frrr-1) — `_chchao-1`

- In GNS3, open the RR node console. Run:
  ```bash
  vtysh
  conf t
  ```
- Paste the **FRR block** from `P3/_chchao-1` (from `hostname` through `line vty`).
- Important: `bgp listen range 1.1.1.0/29 peer-group ibgp` makes the RR accept dynamic BGP peers in that range. The block `address-family l2vpn evpn` with `neighbor ibgp route-reflector-client` is required so EVPN routes are reflected to all VTEPs.

### 2. VTEP1 (frrr-2) — `_chchao-2`

- **Shell first (Linux):**
  ```bash
  ip link add br0 type bridge
  ip link set dev br0 up
  ip link add vxlan10 type vxlan id 10 dstport 4789
  ip link set dev vxlan10 up
  brctl addif br0 vxlan10
  brctl addif br0 eth1
  ```
- **Then FRR:** `vtysh` → `conf t` → paste the FRR block from `_chchao-2`. It must include **`ip ospf area 0`** under interface eth0 and lo (like your note), otherwise OSPF may not come up.

### 3. VTEP2 (frrr-3) — `_chchao-3`

- `vtysh` → `conf t` → paste the FRR block from `_chchao-3` (hostname chchao_2, interface eth1/lo, router bgp, router ospf).

### 4. VTEP3 (frrr-4) — `_chchao-4`

- **Shell first (Linux):**
  ```bash
  ip link add br0 type bridge
  ip link set dev br0 up
  ip link add vxlan10 type vxlan id 10 dstport 4789
  ip link set dev vxlan10 up
  brctl addif br0 vxlan10
  brctl addif br0 eth1
  ```
- **Then FRR:** `vtysh` → `conf t` → paste the FRR block from `_chchao-4` (hostname chchao_4, interface eth2/lo, router bgp, router ospf).

### 5. Check: only type 3, no type 2 (hosts still off)

- On frrr-4 (or any VTEP):  
  `vtysh -c "show ip route"`  
  `vtysh -c "show bgp summary"`  
  `vtysh -c "show bgp l2vpn evpn"`
- You should see **only type 3** routes (inclusive multicast, VNI 10). **No type 2** (no MACs yet because no host is up).

### 6. Start one host (alpine-1), no IP — type 2 appears

- In GNS3, start the host behind VTEP1 (e.g. alpine-1 / _chchao-1_host). In its console run only:  
  `ip link set eth1 up`  
  (no `ip addr add`; see `_chchao-1_host`).
- On frrr-3 (or the VTEP that has that host):  
  `vtysh -c "show bgp l2vpn evpn"`  
  → a **type 2** route should appear with the host’s MAC, e.g. `[2]:[0]:[48]:[92:63:b4:d1:a7:8b]`.
- On the host, confirm MAC: `ifconfig eth1`. Same MAC should show in the EVPN type 2 route. You can also run the same `show bgp l2vpn evpn` on frrr-4 to see the type 2 route reflected via the RR.

### 7. Enable all hosts and add IPs for ping

- Start the other host(s). On each host console:
  - **alpine-1 (host behind VTEP1):**  
    `ip addr add 20.1.1.1/24 dev eth1`
  - **alpine-3 (host behind VTEP3):**  
    `ip addr add 20.1.1.2/24 dev eth0`
- Then from one host: `ping 20.1.1.2` or `ping 20.1.1.1`. Packet inspection: capture on a link and show VXLAN (VNI 10) and OSPF on the underlay.
