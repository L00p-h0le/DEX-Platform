import { useState, useMemo } from 'react';
import './index.css';

function App() {
  const [account, setAccount] = useState('');
  const [activeTab, setActiveTab] = useState('swap');
  
  const [amountIn, setAmountIn] = useState('');
  const [isSwapping, setIsSwapping] = useState(false);
  
  const [poolAmountA, setPoolAmountA] = useState('');
  const [isPooling, setIsPooling] = useState(false);

  // Mock Balances & Reserves for the Demo
  const [userBalanceA, setUserBalanceA] = useState(100.0);
  const [userBalanceB, setUserBalanceB] = useState(50.0);
  const [reserveA, setReserveA] = useState(10000.0);
  const [reserveB, setReserveB] = useState(5000.0);

  // Derived state to ensure instantaneous output updates
  const expectedOut = useMemo(() => {
    if (!amountIn || isNaN(amountIn) || Number(amountIn) <= 0) return '';
    const inVal = Number(amountIn);
    const amountInWithFee = inVal * 997;
    const numerator = amountInWithFee * reserveB;
    const denominator = (reserveA * 1000) + amountInWithFee;
    return (numerator / denominator).toFixed(6);
  }, [amountIn, reserveA, reserveB]);

  const expectedPoolB = useMemo(() => {
    if (!poolAmountA || isNaN(poolAmountA) || Number(poolAmountA) <= 0) return '';
    return ((Number(poolAmountA) * reserveB) / reserveA).toFixed(6);
  }, [poolAmountA, reserveA, reserveB]);

  const connectWallet = async () => {
    try {
      if (window.ethereum) {
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        setAccount(accounts[0]);
      } else {
        setAccount('0x71C...976F'); // Fallback mock connection
      }
    } catch (e) {
      console.warn("Wallet connection rejected, using mock.");
      setAccount('0x71C...976F');
    }
  };

  const handleSwap = () => {
    const inVal = Number(amountIn);
    const outVal = Number(expectedOut);
    
    if (inVal <= 0 || inVal > userBalanceA) return;
    setIsSwapping(true);
    
    setTimeout(() => {
      setUserBalanceA(prev => Math.max(0, prev - inVal));
      setUserBalanceB(prev => prev + outVal);
      setReserveA(prev => prev + inVal);
      setReserveB(prev => prev - outVal);
      setAmountIn('');
      setIsSwapping(false);
    }, 1000);
  };

  const handleAddLiquidity = () => {
    const aVal = Number(poolAmountA);
    const bVal = Number(expectedPoolB);
    
    if (aVal <= 0 || aVal > userBalanceA || bVal > userBalanceB) return;
    setIsPooling(true);
    
    setTimeout(() => {
      setUserBalanceA(prev => Math.max(0, prev - aVal));
      setUserBalanceB(prev => Math.max(0, prev - bVal));
      setReserveA(prev => prev + aVal);
      setReserveB(prev => prev + bVal);
      setPoolAmountA('');
      setIsPooling(false);
    }, 1000);
  };

  const renderSwap = () => (
    <div className="animate-fade-in">
      <div className="input-container">
        <div className="input-header">
          <span>You pay</span>
          <span>Balance: {userBalanceA.toFixed(2)}</span>
        </div>
        <div className="input-row">
          <input 
            type="number" 
            placeholder="0" 
            value={amountIn}
            onChange={(e) => setAmountIn(e.target.value)}
          />
          <div className="token-selector">TKNA ▼</div>
        </div>
      </div>

      <div className="swap-wrapper">
        <div className="swap-icon" onClick={() => {
            // Optional: Mock token inversion visual interaction
        }}>
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><polyline points="19 12 12 19 5 12"></polyline></svg>
        </div>
      </div>

      <div className="input-container">
        <div className="input-header">
          <span>You receive</span>
          <span>Balance: {userBalanceB.toFixed(2)}</span>
        </div>
        <div className="input-row">
          <input 
            type="number" 
            placeholder="0" 
            value={expectedOut}
            readOnly
          />
          <div className="token-selector">TKNB ▼</div>
        </div>
      </div>

      <button 
        className="btn-primary" 
        onClick={account ? handleSwap : connectWallet}
        disabled={isSwapping || (account && (Number(amountIn) <= 0 || Number(amountIn) > userBalanceA))}
      >
        {!account ? 'Connect Wallet' : isSwapping ? 'Swapping...' : (Number(amountIn) > userBalanceA) ? 'Insufficient Balance' : 'Swap'}
      </button>
    </div>
  );

  const renderPool = () => (
    <div className="animate-fade-in">
      <div className="input-container">
        <div className="input-header">
          <span>Input TKNA</span>
          <span>Balance: {userBalanceA.toFixed(2)}</span>
        </div>
        <div className="input-row">
          <input 
            type="number" 
            placeholder="0" 
            value={poolAmountA}
            onChange={(e) => setPoolAmountA(e.target.value)}
          />
          <div className="token-selector">TKNA ▼</div>
        </div>
      </div>
      
      <div className="swap-wrapper">
        <div className="swap-icon-static">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
        </div>
      </div>
      
      <div className="input-container">
        <div className="input-header">
          <span>Input TKNB</span>
          <span>Balance: {userBalanceB.toFixed(2)}</span>
        </div>
        <div className="input-row">
          <input 
            type="number" 
            placeholder="0" 
            value={expectedPoolB}
            readOnly
          />
          <div className="token-selector">TKNB ▼</div>
        </div>
      </div>

      <button 
        className="btn-primary" 
        onClick={account ? handleAddLiquidity : connectWallet}
        disabled={isPooling || (account && (Number(poolAmountA) <= 0 || Number(poolAmountA) > userBalanceA || Number(expectedPoolB) > userBalanceB))}
      >
        {!account ? 'Connect Wallet' : isPooling ? 'Supplying...' : (Number(poolAmountA) > userBalanceA || Number(expectedPoolB) > userBalanceB) ? 'Insufficient Balance' : 'Add Liquidity'}
      </button>
    </div>
  );

  return (
    <>
      <button className="wallet-btn" onClick={connectWallet}>
        {account ? `${account.slice(0,6)}...${account.slice(-4)}` : 'Connect Wallet'}
      </button>

      <div className="glass-panel">
        <div className="tab-container">
          <button 
            className={`tab ${activeTab === 'swap' ? 'active' : ''}`}
            onClick={() => { setActiveTab('swap'); setAmountIn(''); }}
          >
            Swap
          </button>
          <button 
            className={`tab ${activeTab === 'pool' ? 'active' : ''}`}
            onClick={() => { setActiveTab('pool'); setPoolAmountA(''); }}
          >
            Pool
          </button>
        </div>

        {activeTab === 'swap' ? renderSwap() : renderPool()}
        
        <div style={{marginTop: '24px', fontSize: '13px', color: 'var(--text-muted)', textAlign: 'center', padding: '12px', background: 'rgba(0,0,0,0.2)', borderRadius: '12px'}}>
          <div style={{fontWeight: '600', marginBottom: '6px', color: 'var(--text-main)'}}>Current Pool Reserves</div>
          {reserveA.toFixed(0)} TKNA / {reserveB.toFixed(0)} TKNB
        </div>
      </div>
    </>
  );
}

export default App;
