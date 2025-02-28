//
//  State.swift
//  breadwallet
//
//  Created by Adrian Corscadden on 2016-10-24.
//  Copyright © 2016 breadwallet LLC. All rights reserved.
//

import UIKit

struct State {
    let isStartFlowVisible: Bool
    let isLoginRequired: Bool
    let rootModal: RootModal
    let walletState: WalletState
    let isBtcSwapped: Bool
    let currentRate: Rate?
    let rates: [Rate]
    let alert: AlertType?
    let isBiometricsEnabled: Bool
    let defaultCurrencyCode: String
    let recommendRescan: Bool
    let isLoadingTransactions: Bool
    let maxDigits: Int
    let isPushNotificationsEnabled: Bool
    let isPromptingBiometrics: Bool
    let pinLength: Int
    let fees: Fees
}

extension State {
    static var initial: State {
        return State(   isStartFlowVisible: false,
                        isLoginRequired: true,
                        rootModal: .none,
                        walletState: WalletState.initial,
                        isBtcSwapped: UserDefaults.isBtcSwapped,
                        currentRate: UserDefaults.currentRate,
                        rates: [],
                        alert: nil,
                        isBiometricsEnabled: UserDefaults.isBiometricsEnabled,
                        defaultCurrencyCode: UserDefaults.defaultCurrencyCode,
                        recommendRescan: false,
                        isLoadingTransactions: false,
                        maxDigits: UserDefaults.maxDigits,
                        isPushNotificationsEnabled: UserDefaults.pushToken != nil,
                        isPromptingBiometrics: false,
                        pinLength: 6,
                        fees: Fees.defaultFees )
    }
}

enum RootModal {
    case none
    case send
    case receive
    case menu
    case loginAddress
    case loginScan
    case manageWallet
    case requestAmount
}

enum SyncState {
    case syncing
    case connecting
    case success
}

struct WalletState {
    let isConnected: Bool
    let syncProgress: Double
    let syncState: SyncState
    let balance: UInt64?
    let transactions: [Transaction]
    let lastBlockTimestamp: UInt32
    let name: String
    let creationDate: Date
    let isRescanning: Bool
    let zerocoinBalance: UInt64?
    static var initial: WalletState {
        return WalletState(isConnected: false, syncProgress: 0.0, syncState: .success, balance: nil, transactions: [], lastBlockTimestamp: 0, name: S.AccountHeader.defaultWalletName, creationDate: Date.zeroValue(), isRescanning: false, zerocoinBalance: nil)
    }
}

extension WalletState : Equatable {}

func ==(lhs: WalletState, rhs: WalletState) -> Bool {
    return lhs.isConnected == rhs.isConnected && lhs.syncProgress == rhs.syncProgress && lhs.syncState == rhs.syncState && lhs.balance == rhs.balance && lhs.transactions == rhs.transactions && lhs.name == rhs.name && lhs.creationDate == rhs.creationDate && lhs.isRescanning == rhs.isRescanning && lhs.zerocoinBalance == rhs.zerocoinBalance
}
