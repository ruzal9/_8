//: A UIKit based Playground for presenting user interface
  
import UIKit
struct Money {
    var amount: Decimal
    var currency: String
}
extension Money: CustomStringConvertible {
    var description: String {"\(amount)\(currency)"}
}

enum BankAccountError: Error {
    case insufficientAmount
    case convertionError(providedCurency: String,accountCurrency: String)
    case fraudWarning


var localizedDescription: String {
    switch self  {
    case.insufficientAmount:
        return "Недостаточно средтв на счете"

    case .convertionError(let provided,let supported):
    return "ошибка вывода средств в \(provided).Валюта счета:\(supported)"
    case .fraudWarning:
    return "за попытку обмануть банкира вам грозит пожизненая"
        }
    }
}

extension BankAccountError: CustomStringConvertible {
    var description: String {self.localizedDescription}
}

class BankAccaunt {
    var balanse: Money
    init(initialBalanse:Money) {
        balanse = initialBalanse
    }
    func deposit(money:Money) -> BankAccountError? {
        guard money.amount > 0 else { return BankAccountError.fraudWarning }
        guard money.currency == balanse.currency else {
            return BankAccountError.convertionError(providedCurency: money.currency, accountCurrency: balanse.currency)
        }
        balanse.amount += money.amount
        return nil
    }
    func witdraw(amount: Decimal) -> (amount: Money?,error: BankAccountError?) {
        guard amount > 0 else {
            return (amount: nil, error: BankAccountError.fraudWarning)}
        guard amount <= balanse.amount else {
            return (amount: nil, error:BankAccountError.insufficientAmount)
        }
        balanse.amount -= amount
        return ( amount:Money(amount: amount, currency: balanse.currency), error:nil)
    }
}

extension BankAccaunt: CustomStringConvertible {
    var description: String {
        "Состояние счета:\(balanse)"
    }
}
var account = BankAccaunt(initialBalanse: .init(amount: 1000.0, currency: "RUR"))
if let error = account.deposit(money:Money(amount: -100, currency: "RUR")) {
    print("Внимательно !\( error )")
} else {
    print(account)
}
let result = account.witdraw(amount: 300.0)
if let amount = result.amount {
    print ("Вы ввели :\(amount).\(account)")
} else if let error = result.error {
    print(error)
}


    
extension BankAccaunt {
    func unsafeDeposit(money:Money) throws {
        guard money.amount > 0  else {
            throw BankAccountError.fraudWarning
        }
        guard money.currency == balanse.currency else {
            throw BankAccountError.convertionError(providedCurency: money.currency, accountCurrency: balanse.currency)
        }
    
        balanse.amount += money.amount
   }
    func unsafeWitdraw(amount: Decimal) throws -> Money {
        guard amount > 0 else { throw BankAccountError.fraudWarning }
        guard amount <= balanse.amount else {throw BankAccountError.insufficientAmount}
        
        balanse.amount -= amount
        return Money(amount: amount, currency: balanse.currency)
    
    }
}
do {
    let money = try account.unsafeWitdraw(amount: 1200.0)
    print("Cнял денег:\(money)")
}catch let error {
    print(error)
}
do {
    let neWAmount = Money(amount: 1000, currency: "RON")
    try account.unsafeDeposit(money: neWAmount)
    
} catch BankAccountError.fraudWarning {
    print("Об инциденте будет доложено!")
    
} catch BankAccountError.convertionError(let provided, let supported) {
    print("странный вы человек:\(supported) от \(provided) отличить не можете?")
} catch let error {
    print(error.localizedDescription)
}
