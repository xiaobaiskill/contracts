BSC pancake 合约
---
### 1、合约说明
#### 1.1 PancakeRouter
```
可以用户创建池子
可以用于swap代币
    swapExactTokensForTokens  卖币
    swapTokensForExactTokens  买币
```

#### 1.2 PancakeFactory
```
pair 的工厂合约,用来创建 pair 的
```

#### 1.3 PancakePair
```
交易池, 资金所在地
```


### 执行流程
```
1、部署合约, 该合约用来检测, erc20 是否可以正常买卖
2、加入 一定金额的pool 后, 购买erc20. 
3、将该合约加入监控, 待达到一定金额后 卖出 or 在抵达成本之前卖出 or 在撤销pool 之前卖出
```