//
//  ATHBoardViewController.m
//  Memory
//
//  Created by Arnau Timoneda Heredia on 15/04/14.
//  Copyright (c) 2014 Arnau Timoneda Heredia. All rights reserved.
//

#import "ATHBoardViewController.h"
#import "ATHGame.h"
#import <AVFoundation/AVFoundation.h>

@interface ATHBoardViewController ()

@end

@implementation ATHBoardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)createCards:(int)numCards{
    //Dos cartas tendrán el mismo id, serán la pareja. El secondCard lo usaremos para diferenciar
    //las cartas con el mismo id.
    
    //int pantallaW = [[self view]bounds].size.width;
    //int pantallaH = [[self view]bounds].size.height;
    
    int h = 0;//Número de columnas
    int v = 0;//Número de filas
    
    switch (numCards) {
        case 12:
            h = 4;
            v = 3;
            break;
        case 16:
            h = 4;
            v = 4;
            break;
        case 20:
            h = 5;
            v = 4;
            break;
        case 24:
            h = 6;
            v = 4;
            break;
        case 30:
            h = 6;
            v = 5;
            break;
        case 36:
            h = 6;
            v = 6;
            break;
        default:
            break;
    }
    
    int dh = ([[self view]bounds].size.width - (h*100))/(h+1);//Ancho de pantalla, menos el ancho que ocupan todas las fichas dividido entre numero de fichas +1
    
    int dv = (([[self view]bounds].size.height - 300) - (v*100))/(v+1);
    int div = 150;//distancia inicial vertical
    
    NSMutableArray *randomCards = [self createDisorderedArray:numCards];
    
    int num = 0;
    for (int i = 0; i<v; i++) {//filas
        for (int j = 0; j<h; j++){//columnas
            ATHCard *currentCard = [ATHCard alloc];
            
            int idCards = [self getId:randomCards[num] withIdSelect:0];
            int secondCard = [self getId:randomCards[num] withIdSelect:1];
            
            currentCard.idPartner = idCards;
            currentCard.completed = false;
            
            CALayer *testLayer = [CALayer layer];
            testLayer.bounds = CGRectMake(0.0, 0.0, 100.0, 100.0);
            testLayer.contents = (id) [UIImage imageNamed:@"CardBack.png"].CGImage;
            testLayer.anchorPoint = CGPointMake(0.0, 1.0);
            //testLayer.position = CGPointMake(([[self view]bounds].size.width/2)-50.0, ([[self view]bounds].size.height/3.0)+5);
            int primero = ((j+1)*dh) + (j*100);
            int segundo = (div+((i+1)*dv)) + (i*100);
            testLayer.position = CGPointMake(primero, segundo+100);
            testLayer.cornerRadius = 10.0;
            testLayer.borderWidth = 2.0;
            testLayer.borderColor =[[UIColor redColor] CGColor];
            //el .name sera de tipo 00, 01, 10, 11, 20, 21... donde el primer dígito sera el idParter y el segundo para diferenciar 2 cartas iguales
            testLayer.name = [NSString stringWithFormat:@"%d%d",idCards, secondCard];
            
            num++;
            NSLog(@"Ficha numero: %d , con id: %d%d", num, idCards, secondCard);
            
            testLayer.masksToBounds = YES;
            [self.backgroundImage.layer addSublayer:testLayer];
            currentCard.layer = testLayer;
            
            [_mainGame.cards addObject:currentCard];
            
        }
    }
}

//4x3(12) 4x4(16) 5x4(20) 6x4(24) 6x5(30) 6x6(36)
//4x3(12)
- (void)viewDidLoad
{
    [super viewDidLoad];
    //EJECUTA AL CARGAR LA VISTA
    
    //Creamos la partida, inicializamos el array de cartas, inicializamos la puntuacion y llamamos al método crear cartas.
    _firstCard = nil;
    _readyToPlay = TRUE;
    ATHGame *game = [ATHGame alloc];
    _mainGame = game;
    game.cards = [[NSMutableArray alloc] init];
    
    ATHScore *score = [ATHScore alloc];
    game.score = score;
    score.score = 0;
    [self createCards:36];

    
    NSLog(@"main game test: %ld", _mainGame.score.score);
    
}

- (void)cardClicked:(ATHCard*) card{
    //Cuando clicamos a una carta, mostramos su imagen, miramos si es primer o segundo click, y si es el segundo aplicamos un delay y comprovamos si coincide con el primer. Si coinciden marcamos las cartas como completadas y dejamos preparado para la siguiente jugada.
    
    if(_readyToPlay){
        if (!card.isCompleted) {
            card.layer.contents = (id) [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",card.layer.name]].CGImage;
            if(_firstCard == nil){
                _firstCard = card;
            }else{
                if(card == _firstCard){
                    NSLog(@"Misma Carta! --> do nothong");
                }else{
                    _readyToPlay = false;
                    int lengthFirstCard = 1;
                    if ([_firstCard.layer.name length] == 3){
                        lengthFirstCard = 2;
                    }
                
                    int LengthSecondCard = 1;
                    if([card.layer.name length] == 3) {
                        LengthSecondCard = 2;
                    }
                    if([[_firstCard.layer.name substringToIndex:lengthFirstCard] isEqualToString:[card.layer.name substringToIndex:LengthSecondCard]]){
                        _firstCard.completed = true;
                        card.completed = true;
                        NSLog(@"Su pareja!");
                    
                        //SOUND
                        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"caf"];
                        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
                        self.couple = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
                        [self.couple play];
                        //EXIT SOUND
                    
                        if([self gameCompleted]){
                            NSLog(@"Partida Finalizada!");
                            //SOUND
                            NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"caf"];
                            NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
                            self.endGame = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
                            [self.endGame play];
                            //EXIT SOUND
                        }
                        _firstCard = nil;
                        _readyToPlay = true;
                    }else{
                    
                        double delayInSeconds = 1.0;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            NSLog(@"black1--> %@ ", _firstCard.layer.name);
                            _firstCard.layer.contents = (id) [UIImage imageNamed:@"CardBack.png"].CGImage;
                            NSLog(@"black2--> %@ ", card.layer.name);
                            card.layer.contents = (id) [UIImage imageNamed:@"CardBack.png"].CGImage;
                            _firstCard = nil;
                            _readyToPlay = true;
                        });
                    
                        //SOUND WRONG
               /*       NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"caf"];
                        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
                        self.wrong = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
                        [self.wrong play]; */
                        //EXIT SOUND
                        NSLog(@"Wrong!");
                    }
                
                }
            }
        }
    } else {
        NSLog(@"not ready yet");
    }
}


- (bool) gameCompleted{
    //Recorre todo el array de fichas comprobando si estan completados o no. Devuelve si se ha terminado la partida o no.
    bool result = true;
    
    for (ATHCard *crd in _mainGame.cards){
        if (crd.completed == false){
            result =false;
            break;
        }
    }
    return result;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    //Este método detecta cuando se ha hecho click en la pantalla. Cogemos el punto exacto en p y recorremos todas las layers que hay en la vista hasta que encontramos el layer en el que pertenece el punto. Una vez tenemos el layer, con su .name tenemos el id y con ese id llamaos al método getCardById que nos devuelve la carta que tiene ese ID.
    CGPoint p = [(UITouch*)[touches anyObject] locationInView:self.view];
    NSLog(@"touched:: %f, %f", p.x, p.y);
    for (CALayer *layer in self.backgroundImage.layer.sublayers) {
        if ([layer containsPoint:[self.view.layer convertPoint:p toLayer:layer]]) {
            NSLog(@"layer name: %@", layer.name);
            ATHCard *cardClicked = [self getCardById:layer.name];
            NSLog(@"Ficha pulsada %@", cardClicked.layer.name);
            [self cardClicked:cardClicked];
            break;
        }
    }
}

//Devuelve un objeto carta según el id dado
- (ATHCard*)getCardById:(NSString*) idCard{
    ATHCard *result = nil;
    
    for (ATHCard *crd in _mainGame.cards){
        if([idCard isEqualToString:crd.layer.name] ){
            result = crd;
            break;
        }
    }
    
    return result;
}


//Crea un array con todos los ID's de las cartas, los mete en un Array y luego los va cogiendo random para desordenarlos en otro array.
- (NSMutableArray*)createDisorderedArray:(int) numCards{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSInteger myNums[36] = {10,11,20,21,30,31,40,41,50,51,60,61,70,71,80,81,90,91,100,101,110,111,120,121,130,131,140,141,150,151,160,161,170,171,180,181};
    NSMutableArray *allCards = [[NSMutableArray alloc] init];
    for (int i = 0; i<numCards; i++){
        [allCards addObject:[NSNumber numberWithInt:(int)myNums[i]]];
    }
    while ([allCards count] != 0){
        int randNum = arc4random_uniform((u_int32_t)[allCards count]);
        [result addObject:[allCards objectAtIndex:randNum]];
        [allCards removeObjectAtIndex:randNum];
    }
    return result;
}

//Recibe un number que es el id completo de una carta. Si idType es 0, cojerá el id de la carta (primer valor), si el idType es 1, se quedara con el idSecondCard (segundo valor).
- (int)getId:(NSNumber*)numID withIdSelect:(int)idType{
    NSString *result = nil;
    NSString *idComplete = [numID stringValue];
    if ([idComplete length] == 2){
        if (idType == 0){
            result = [idComplete substringToIndex:1];
        } else if (idType == 1){
            result = [idComplete substringFromIndex:1];
        }
    } else if ([idComplete length] == 3){
        if (idType == 0){
            result = [idComplete substringToIndex:2];
        } else if (idType == 1){
            result = [idComplete substringFromIndex:2];
        }
    }
    return [result intValue];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
