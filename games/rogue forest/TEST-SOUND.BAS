/ � �($400)�0 � �"RF-EFFECTS.PRG",8,1,$0400 9
 � "�" H AD � $0522 Y R  � �(AD�0) j FL � �(AD�1) { FH � �(AD�2) � W  � �(AD�3) � VL � �(AD�4) � VH � �(AD�5) � WL � �(AD�6) � WH � �(AD�7) � GL � �(AD�8) � GH � �(AD�9) 	d � " FEATURE         UP DN" 0	i � " -------------   -- --" Q	n � " RELEASE COUNT    Q  A",R v	x � " FREQUENCY        W  S",FH,FL �	� � " WAVEFORM         E  D",W �	� � " VOLUME           R  F",VH,VL �	� � " VOL-CHANGE       T  G",WH,WL 
� � " FREQ CHANGE      Y  H",GH,GL 
� � $0406  :� ZAP 1
� � A$ :� A$�""� 200 F
� � $040C  :� STOP _
� � A$�"Q" � � AD, R�1 x
� � A$�"A" � � AD, R�1 �
� � A$�"W" � � AD�2, FH�1 �
� � A$�"S" � � AD�2, FH�1 �
� � A$�"E" � � AD�3, W�1 �
� A$�"D" � � AD�3, W�1 � A$�"R" � � AD�5, VH�1 � A$�"F" � � AD�5, VH�1 :"� A$�"G" � � AD�7, WH�1 Y,� A$�"Y" � POCK AD�9, GH�1 x6� A$�"H" � POCK AD�9, GH�1 �;� $040F  :� RESTART �@� 10   