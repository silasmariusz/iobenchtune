I/O Bench Tune for QNAP Copyright (c) 2018, Silas Mariusz &lt;silas@qnap....pl>


Please refer to Reviewer’s Guide, Storage Performance Benchmarking Guidelines and learn more about usage of IOBenchTune-QNAP.




Understanding...



What is IOPS?

IOPS is number of requests that your application is sending to the storage disks in one second. An input/output operation could be read or write, sequential or random. OLTP applications like an online retail website need to process many concurrent user requests immediately. The user requests are insert and update intensive database transactions, which the application must process quickly. Therefore, OLTP applications require very high IOPS. Such applications handle millions of small and random IO requests. If you have such an application, you must design the application infrastructure to optimize for IOPS.



What is Throughput?

Throughput or Bandwidth is the amount of data that your application is sending to the storage disks in a specified interval. If your application is performing input/output operations with large IO unit sizes, it requires high Throughput. Data warehouse applications tend to issue scan intensive operations that access large portions of data at a time and commonly perform bulk operations. In other words, such applications require higher Throughput. If you have such an application, you must design its infrastructure to optimize for Throughput.



What is Latency?

Latency is the time it takes an application to receive a single request, send it to the storage disks and send the response to the client. This is a critical measure of an application's performance in addition to IOPS and Throughput. If you enable SSD disk caching on server storage disks, you can get much lower read latency.



Usage

Run container on desired volume to perform benchmark tests. One its done, get the results from output file results.txt and fill in the spreedsheet file attached in Reviewer’s Guide, Storage Performance Benchmarking Guidelines.



Appendix

n/A



Learn more



NAS Management

https://www.qnap.com/en/enterprise_apply_v2/con_show.php?op=showone&cid=7

iSCSI & Virtualization

https://www.qnap.com/en/enterprise_apply_v2/con_show.php?op=showone&cid=4

SSD Caching & Acceleration

https://www.qnap.com/solution/ssd-cache/en/#hb-4f

Storage Performance Best Practices

https://www.qnap.com/en/how-to/tutorial/article/qnap-storage-performance-best-practice
